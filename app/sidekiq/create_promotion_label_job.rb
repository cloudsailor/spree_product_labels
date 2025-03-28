# frozen_string_literal: true

class CreatePromotionLabelJob
  include Sidekiq::Job

  def perform(product_id, store_id)
    product = ::Spree::Product.find(product_id)
    store = ::Spree::Store.find(store_id) || ::Spree::Store.find_by(default_locale: I18n.locale.to_s) || ::Spree::Store.current

    promotion_label = ::Spree::Label.where(label_type: 'Promotion', store: store).first_or_initialize do |label|
      label.attributes = { label_type: 'Promotion', position: 1, active: true, end_date: nil, store: store }
    end
    promotion_label.save! unless promotion_label.persisted?
    return if product.labels.include? promotion_label

    product.labels << promotion_label
  end
end
