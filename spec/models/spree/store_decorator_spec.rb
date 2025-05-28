# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Spree::Store, type: :model do
  before { Spree::Store.prepend Spree::StoreDecorator }

  describe 'associations' do
    it 'has correct association options for :labels' do
      reflection = described_class.reflect_on_association(:labels)

      expect(reflection).not_to be_nil
      expect(reflection.macro).to eq(:has_many)
      expect(reflection.class_name).to eq('Spree::Label')
      expect(reflection.foreign_key).to eq('store_id')
      expect(reflection.inverse_of.name).to eq(:store)
    end
  end

  describe 'labels behavior' do
    let(:store) { create(:store) }
    let!(:label) { create(:label, store: store) }

    it 'associates labels correctly' do
      expect(store.labels).to include(label)
    end
  end
end
