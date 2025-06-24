# frozen_string_literal: true

module Spree
  module V2
    module Storefront
      module ProductSerializerDecorator
        def self.prepended(base)
          base.attribute :label, &:first_active_label
          base.attribute :label_color, &:first_active_label_color
        end
      end
    end
  end
end
