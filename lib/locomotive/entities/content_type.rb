module Locomotive
  module Entities
    class ContentType
      include Locomotive::Entity

      ## fields ##
      attr_accessor :name, :description, :slug, :label_field_name, :group_by, :order_by, 
                    :order_direction, :public_submission_enabled,:public_submission_accounts,
                    :raw_item_template, :fields, :entries

    end
  end
end
