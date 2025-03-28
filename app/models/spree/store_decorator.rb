# frozen_string_literal: true

module Spree
  module StoreDecorator
    def self.prepended(base)
      base.has_many :labels, class_name: 'Spree::Label', foreign_key: 'store_id', dependent: :destroy, inverse_of: :store
    end
  end
end
Spree::Store.prepend Spree::StoreDecorator if Spree::Store.included_modules.exclude?(Spree::StoreDecorator)
