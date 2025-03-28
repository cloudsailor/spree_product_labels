# frozen_string_literal: true

module Spree
  module ProductDecorator
    def self.prepended(base)
      return if base.reflect_on_association(:labels)

      base.has_and_belongs_to_many :labels, class_name: 'Spree::Label', join_table: 'labels_products'
      base.after_save :assign_promotion_labels
    end

    def first_active_label
      all_active_labels = labels.where('start_date <= ? AND end_date >= ?', Time.zone.today, Time.zone.today)
                                .or(labels.where(always_active: true))

      priority_positions = labels.where(active: true).pluck(:position).uniq.sort

      priority_positions.each do |pos|
        label = labels.find_by(
          lang_code: I18n.locale.to_s,
          active: true,
          position: pos,
          id: all_active_labels.select(:id)
        )
        return label&.name if label.present?
      end
    end

    private

    def assign_promotion_labels
      label_store = Spree::Store.current || Spree::Store.find_by(default_locale: I18n.locale.to_s)
      return unless prices_promotion? || default_price_promotion?

      promotion_label = ::Spree::Label.where(name: 'Promotions', store: label_store).first_or_initialize do |label|
        label.attributes = {
          name: 'Promotions', label_type: 'Promotion', position: 1,
          active: true, end_date: nil, store: label_store
        }
      end
      promotion_label.save! unless promotion_label.persisted?
      return if labels.include? promotion_label

      labels << promotion_label
    end

    def prices_promotion?
      prices&.any? do |price|
        price.compare_at_amount.present? && price.compare_at_amount > price.amount
      end
    end

    def default_price_promotion?
      default_price = default_variant.default_price
      return false unless default_price

      default_price.compare_at_amount.present? && default_price.compare_at_amount > default_price.amount
    end
  end
end
Spree::Product.prepend Spree::ProductDecorator if Spree::Product.included_modules.exclude?(Spree::ProductDecorator)
