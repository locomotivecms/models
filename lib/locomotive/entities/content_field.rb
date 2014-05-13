module Locomotive
  module Entities
    class ContentField
      include Locomotive::Entity

      attributes  :label, :name, :type, :hint, :position, 
                  :required, :unique, :localized, :text_formatting, :select_options,
                  :class_slug, :class_name, :inverse_of, :order_by, :ui_enabled

    end
  end
end
