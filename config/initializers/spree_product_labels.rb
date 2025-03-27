# frozen_string_literal: true

Rails.application.config.after_initialize do
  if ActiveRecord::Base.connection.data_source_exists?('spree_labels')
    Spree::Product.prepend Spree::ProductDecorator
    Spree::Store.prepend Spree::StoreDecorator
    Spree::V2::Storefront::ProductSerializer.prepend Spree::V2::Storefront::ProductSerializerDecorator
  end
end
