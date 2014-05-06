module Locomotive
  class Mapper

    attr_reader :collections

    def initialize
      @collections = {}
    end

    def load_association! object, attribute
      objects = Array(object)
      # dereferencer = Dereferencer.new(mapper_registry, identity_map)
      # dereferencer.load objects.map { |obj| obj.instance_variable_get("@#{attribute}") }
      #
      # objects.each do |obj|
      #   reference = obj.instance_variable_get("@#{attribute}")
      #   if reference.is_a? Array
      #     refs = reference
      #     real_objects = refs.map { |ref| dereferencer[ref] }
      #     inject_attribute obj, attribute, real_objects
      #   else
      #     inject_attribute obj, attribute, dereferencer[reference]
      #   end
      # end
    end


    def collection(name)
      @collections[name] = Mapping::Collection.new(name)
    end
  end
end
