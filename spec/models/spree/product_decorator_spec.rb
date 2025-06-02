# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Spree::Product, type: :model do
  before { Spree::Product.prepend Spree::ProductDecorator }

  describe 'associations' do
    it 'has many labels through labels_products' do
      association = described_class.reflect_on_association(:labels)

      expect(association).not_to be_nil
      expect(association.macro).to eq(:has_and_belongs_to_many)
      expect(association.class_name).to eq('Spree::Label')
      expect(association.join_table).to eq('labels_products')
    end
  end

  describe '#first_active_label' do
    let!(:store) { create(:store, default_locale: I18n.locale) }
    let!(:product) { create(:product) }

    let(:promo_label) do
      create(:label, store: store, active: true, label_type: 'promo', name: 'Promo Label',
                     position: 1, start_date: 2.days.ago, end_date: Time.zone.today)
    end

    let(:info_label) do
      create(:label, store: store, active: true, label_type: 'info', name: 'Info Label',
                     position: 2, start_date: Time.zone.today + 1.day, end_date: Time.zone.today + 2.days)
    end

    it 'returns the name of the active label with the highest priority' do
      product.labels << [promo_label, info_label]

      expect(product.first_active_label).to eq('Promo Label')
    end

    context 'when label has no end_date (always active)' do
      let(:active_label) do
        create(:label, store: store, active: true, name: 'Always Active', label_type: 'type_b',
                       position: 0, start_date: 2.days.ago, end_date: nil)
      end

      it 'prefers always active label if it has higher priority' do
        product.labels << active_label

        expect(product.first_active_label).to eq('Always Active')
      end
    end

    context 'when no labels are active' do
      it 'returns nil' do
        promo_label.update(active: false)
        info_label.update(active: false)

        expect(product.first_active_label).to eq(nil)
      end
    end
  end

  describe '#first_active_label_color' do
    let!(:store) { create(:store, default_locale: I18n.locale) }
    let!(:product) { create(:product) }

    let(:promo_label) do
      create(:label, store: store, active: true, label_type: 'promo', name: 'Promo Label',
                     position: 1, start_date: 2.days.ago, end_date: Time.zone.today, color: '#FF0000')
    end

    let(:info_label) do
      create(:label, store: store, active: true, label_type: 'info', name: 'Info Label',
                     position: 2, start_date: Time.zone.today + 1.day, end_date: Time.zone.today + 2.days, color: '#00FF00')
    end

    it 'returns the color of the active label with the highest priority' do
      product.labels << [promo_label, info_label]

      expect(product.first_active_label_color).to eq('#FF0000')
    end

    context 'when label has no end_date (always active)' do
      let(:active_label) do
        create(:label, store: store, active: true, name: 'Always Active', label_type: 'type_b',
                       position: 0, start_date: 2.days.ago, end_date: nil, color: '#0000FF')
      end

      it 'prefers always active label if it has higher priority' do
        product.labels << active_label

        expect(product.first_active_label_color).to eq('#0000FF')
      end
    end

    context 'when no labels are active' do
      it 'returns nil' do
        promo_label.update(active: false)
        info_label.update(active: false)

        expect(product.first_active_label_color).to eq(nil)
      end
    end
  end
end
