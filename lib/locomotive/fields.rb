module Locomotive
  module Fields
    extend ActiveSupport::Concern

    class FieldDoesNotExistException < StandardError ; end

    included do
      include ActiveSupport::Callbacks
      define_callbacks :initialize
      class << self; attr_accessor :_fields end
    end

    # Default constructor
    #
    # @param [ Hash ] attributes The new attributes
    #
    def initialize(attributes = {})
      run_callbacks :initialize do
        _attributes = attributes.symbolize_keys
        set_default _attributes
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

        unless field_not_exists?(name) || not_dynamic_attribute?(name)
          attribute_cannot_be_written! name, value
        end

        self.send(:"#{name}=", value)
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
    # deprecate :attributes_with_translations, :attributes

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

    protected

    def getter(name, options = {})
      self.instance_variable_get(:"@#{name}").try(:value)
    end

    def setter(name, value, options = {})
      _field = field_object(name, options)
      _field.value = value
      self.instance_variable_set(:"@#{name}", _field)
    end

    def field_object name, options
      self.instance_variable_get(:"@#{name}") || if self.localized_field?(name)
        I18nField.new options
      else
        case options[:type]
        when :array
          ArrayField.new options
        else
          BaseField.new options
        end
      end
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
            self.setter '#{name}', value, self.class._fields[:#{name}]
          end

          def #{name}_localized?
            #{options[:localized]}
          end
        EOV
      end

    end

    private

    # def with_one_translation_give_the_first_value value
    #   if value.size == 1
    #     value = value.values.first if value.size == 1
    #     value = nil if value.respond_to?(:empty?) && value.empty?
    #   end
    #   value
    # end

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

    def not_dynamic_attribute? name
      self.respond_to?(:"#{name}=")
    end

    def attribute_cannot_be_written! name, value
      raise FieldDoesNotExistException.new(
        "[#{self.class.inspect}] setting an unknown attribute '#{name}' with the value '#{value.inspect}'")
    end

    def _locales
      [].tap do |locales|
        self.class._fields.each do |name, options|
          if localized_field?(name)
            (self.instance_variable_get(:"@#{name}").try(:locales)||[]).each do |_locale|
              locales << _locale unless locales.include?(_locale)
            end
          end
        end
      end
    end
  end
end
