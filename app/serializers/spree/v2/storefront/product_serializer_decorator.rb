# frozen_string_literal: true

module Spree
  module V2
    module Storefront
      module ProductSerializerDecorator
        def self.prepended(base)
          base.attribute :label do |product, params|
            product.first_active_label(store: params[:store])
          end

          base.attribute :label_color do |product, params|
            product.first_active_label_color(store: params[:store])
          end
        end
      end
    end
  end
end
