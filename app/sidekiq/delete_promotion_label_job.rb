# frozen_string_literal: true

class DeletePromotionLabelJob
  include Sidekiq::Job

  def perform(product_id, store_id)
    product = ::Spree::Product.find(product_id)
    store = ::Spree::Store.find(store_id) || ::Spree::Store.find_by(default_locale: I18n.locale.to_s) || ::Spree::Store.current
    promotion_label = product.labels.find_by(label_type: 'Promotion', store: store)

    product.labels.delete(promotion_label)
  end
end
