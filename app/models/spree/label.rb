# frozen_string_literal: true

module Spree
  class Label < ApplicationRecord
    belongs_to :store, class_name: 'Spree::Store'
    has_and_belongs_to_many :products, class_name: 'Spree::Product', join_table: 'labels_products'

    validates :name, :label_type, presence: true
    validate :end_date_after_start_date
    validate :only_one_active_label_per_priority
    validate :only_one_active_label_per_type
    validate :no_overlapping_validity_dates

    def always_active
      end_date.nil?
    end

    private

    def end_date_after_start_date
      return if always_active
      return unless start_date.present? && end_date.present?

      errors.add(:end_date, Spree.t('admin.label.validates.end_date_after_start_date')) if end_date < start_date
    end

    def only_one_active_label_per_priority
      values = { active: true, position: position, store: store }
      return unless active?
      return unless self.class.where(values).where.not(id: id).exists?

      errors.add(:position, Spree.t('admin.label.validates.only_one_active_label_per_priority', position: position))
    end

    def only_one_active_label_per_type
      values = { label_type: label_type, active: true, store: store }
      return unless active?
      return unless self.class.where(values).where.not(id: id).exists?

      errors.add(:base, Spree.t('admin.label.validates.only_one_active_label_per_type'))
    end

    def no_overlapping_validity_dates
      return if always_active

      overlapping_labels = self.class.where(label_type: label_type)
                               .where.not(id: id)
                               .where(
                                 '(start_date, end_date) OVERLAPS (?, ?)',
                                 start_date, end_date
                               )
      return unless overlapping_labels.exists?

      errors.add(:base, Spree.t('admin.label.validates.no_overlapping_validity_dates'))
    end
  end
end
