# frozen_string_literal: true

module Spree
  module ProductDecorator
    def self.prepended(base)
      return if base.reflect_on_association(:labels)

      base.has_and_belongs_to_many :labels, class_name: 'Spree::Label', join_table: 'labels_products', optional: true
    end

    def first_active_label(store:)
      first_matching_label(store: store)&.name
    end

    def first_active_label_color(store:)
      first_matching_label(store: store)&.color
    end

    private

    def first_matching_label(store:)
      all_active_labels = labels.where(
        '(start_date <= ? AND end_date >= ?) OR end_date IS NULL',
        Time.zone.today, Time.zone.today
      )

      priority_positions = labels.where(active: true).pluck(:position).uniq.sort

      priority_positions.each do |pos|
        label = labels.find_by(
          store_id: store.id,
          active: true,
          position: pos,
          id: all_active_labels.select(:id)
        )
        return label if label.present?
      end

      nil
    end
  end
end
