module Locomotive
  module Fields
    extend ActiveSupport::Concern

    class FieldDoesNotExistException < StandardError ; end

    included do
      include ActiveSupport::Callbacks
      define_callbacks :initialize
      class << self; attr_accessor :_fields end
      attr_accessor :_locales
    end

    # Default constructor
    #
    # @param [ Hash ] attributes The new attributes
    #
    def initialize(attributes = {})
      run_callbacks :initialize do
        _attributes = attributes.symbolize_keys
        set_default _attributes

        # set default translation
        self.add_locale(Locomotive::Models.locale)
        self.write_attributes(_attributes)
      end
    end

    # Set or replace the attributes of the current instance by the ones
    # passed as parameter.
    # It raises an exception if one of the keys is not included in the list of fields.
    #
    # @param [ Hash ] attributes The new attributes
    #
    def write_attributes(attributes)
      Array(attributes).each do |name, value|
        next if identity?(name)

        unless field_not_exists?(name) || attribute_not_exists?(name)
          attribute_cannot_be_written! name, value
        end

        if self.localized_field?(name) && value.respond_to?(:to_hash)
          self.send(:"#{name}_translations=", value.to_hash)
        else
          self.send(:"#{name}=", value)
        end
      end
    end
    alias :attributes= :write_attributes

    # Return the fields with their values
    #
    # @return [ Hash ] The attributes
    #
    def attributes
      {}.tap do |_attributes|
        self.class._fields.each do |name, options|
          _attributes[name] = self.send(name.to_sym)
        end
      end
    end

    # Return the fields with their values and their translations
    #
    # @return [ Hash ] The attributes
    #
    def attributes_with_translations
      {}.tap do |_attributes|
        self.class._fields.each do |name, options|
          next if options[:association]

          if options[:localized]
            value = self.send(:"#{name}_translations")
            # TODO should be modified
            value = value.values.first if value.size == 1
            value = nil if value.respond_to?(:empty?) && value.empty?
            _attributes[name] = value
          else
            _attributes[name] = self.send(name.to_sym)
          end
        end
      end
    end

    # Check if the field specified by the argument is localized
    #
    # @param [ String ] name Name of the field
    #
    # @return [ Boolean ] True if the field is localized
    #
    def localized_field?(name)
      method_name = :"#{name}_localized?"
      self.respond_to?(method_name) && self.send(method_name)
    end

    # List all the translations done on that model
    #
    # @return [ List ] List of locales
    #
    def translated_in
      self._locales.map(&:to_sym)
    end

    # Tell if the object has been translated in the locale
    # passed in parameter.
    #
    # @param [ String/Symbol ] locale
    #
    # @return [ Boolean ] True if one of the fields has been translated.
    #
    def translated_in?(locale)
      self.translated_in.include?(locale.to_sym)
    end

    # Return a Hash of all the non blank attributes of the object.
    # It also performs a couple of modifications: stringify keys and
    # convert Symbol to String.
    #
    # @param [ Boolean ] translation Flag (by default true) to get the translations too.
    #
    # @return [ Hash ] The non blank attributes
    #
    def to_hash(translations = true)
      hash = translations ? self.attributes_with_translations : self.attributes
      hash.delete_if { |k, v| (!v.is_a?(FalseClass) && v.blank?) }
      hash.each { |k, v| hash[k] = v.to_s if v.is_a?(Symbol) }
      hash.deep_stringify_keys
    end

    # Provide a better output of the default to_yaml method
    #
    # @return [ String ] The YAML version of the object
    #
    def to_yaml
      # get the attributes with their translations and get rid of all the symbols
      object = self.to_hash

      object.each do |key, value|
        if value.is_a?(Array)
          object[key] = if value.first.is_a?(String)
            StyledYAML.inline(value) # inline array
          else
            value.map(&:to_hash)
          end
        end
      end

      StyledYAML.dump object
    end

    protected

    def getter(name, options = {})
      value = self.instance_variable_get(:"@#{name}")
      value = (value || {})[Locomotive::Models.locale] if options[:localized]
      value
    end

    def setter(name, value, options = {})
      if options[:localized]
        # TODO should be modified
        # keep track of the current locale
        self.add_locale(Locomotive::Models.locale)
        translations = self.instance_variable_get(:"@#{name}") || {}
        translations[Locomotive::Models.locale] = value
        value = translations
        self.instance_variable_set(:"@#{name}", value)

        # translations = self.send(:"#{name}_translations")
        # self.send(:"#{name}_translations=", translations.merge(value.to_hash))
      else
        if options[:type] == :array
          klass = options[:class_name].constantize
          value = value.map { |object| object.is_a?(Hash) ? klass.new(object) : object }
        end
        self.instance_variable_set(:"@#{name}", value)
      end
    end

    def add_locale(locale)
      self._locales ||= []
      self._locales << locale.to_sym unless self._locales.include?(locale.to_sym)
    end

    module ClassMethods

      # Add a field to the current instance. It creates getter/setter methods related to that field.
      # A field can have translations if the option named localized is set to true.
      #
      # @param [ String ] name The name of the field
      # @param [ Hash ] options The options related to the field.
      #
      def field(name, options = {})
        options = { localized: false }.merge(options)

        @_fields ||= {} # initialize the list of fields if nil

        self._fields[name.to_sym] = options

        class_eval <<-EOV
          def #{name}
            self.getter '#{name}', self.class._fields[:#{name}]
          end

          def #{name}=(value)
            self.setter '#{name}', value, self.class._fields[:#{name}] #, #{options[:localized]}
          end

          def #{name}_localized?
            #{options[:localized]}
          end
        EOV

        if options[:localized]
          class_eval <<-EOV
            def #{name}_translations
              @#{name} || {}
            end

            def #{name}_translations=(translations)
              translations.each { |locale, value| self.add_locale(locale) }
              @#{name} = translations.symbolize_keys
            end
          EOV
        end
      end

    end

    private

    def set_default attributes
      # set default values
      self.class._fields.each do |name, options|
        next if no_default_provided(options) || field_already_defined(attributes, name)
        attributes[name] = options[:default]
      end
    end

    def no_default_provided options
      !options.has_key?(:default)
    end

    def field_already_defined attributes, name
      attributes.has_key?(name)
    end

    def identity? key
      key.to_s == 'id'
    end

    def field_not_exists? name
      self.class._fields.key?(name.to_sym)
    end

    def attribute_not_exists? name
      self.respond_to?(:"#{name}=")
    end

    def attribute_cannot_be_written! name, value
      raise FieldDoesNotExistException.new(
        "[#{self.class.inspect}] setting an unknown attribute '#{name}' with the value '#{value.inspect}'")
    end

  end
end
