# frozen_string_literal: true

module Spree
  module V2
    module Storefront
      module ProductSerializerDecorator
        def self.prepended(base)
          base.attribute :label, &:first_active_label
        end
      end
    end
  end
end
