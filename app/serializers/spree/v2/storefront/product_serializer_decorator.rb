# frozen_string_literal: true

module Spree
  module V2
    module Storefront
      module ProductSerializerDecorator
        def self.prepended(base)
          base.attribute :first_active_label, &:first_active_label
        end
      end
    end
  end
end
if Spree::V2::Storefront::ProductSerializer.included_modules
                                           .exclude?(Spree::V2::Storefront::ProductSerializerDecorator)
  Spree::V2::Storefront::ProductSerializer.prepend Spree::V2::Storefront::ProductSerializerDecorator
end
