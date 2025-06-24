# frozen_string_literal: true

FactoryBot.define do
  FactoryBot.define do
    factory :label, class: 'Spree::Label' do
      sequence(:name) { |n| "Label #{n}" }
      sequence(:description) { |n| "Description #{n}" }
      sequence(:position) { |n| n }
      label_type { 'promo' }
      active { true }
      color { '#0000FF' }
      store

      transient { days_offset { 0 } }

      start_date { days_offset.days.ago.to_date }
      end_date { (days_offset + 1).days.from_now.to_date }
    end
  end
end
