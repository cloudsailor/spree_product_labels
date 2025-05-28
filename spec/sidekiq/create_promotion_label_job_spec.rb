# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreatePromotionLabelJob, type: :job do
  describe '#perform' do
    let(:product) { create(:product) }
    let(:store) { create(:store) }
    let(:label) { create(:label, label_type: 'Promotion', store: store) }

    context 'when product and store exist' do
      it 'finds an existing promotion label and associates it with the product' do
        expect(product.labels).not_to include(label)

        described_class.new.perform(product.id, store.id)
        product.reload

        expect(product.labels).to include(label)
        expect { described_class.new.perform(product.id, store.id) }.not_to(change { ::Spree::Label.count })
      end

      it 'does not duplicate the association if the label is already associated' do
        product.labels << label

        expect { described_class.new.perform(product.id, store.id) }.not_to(change { product.labels.count })
        expect(product.reload.labels).to include(label)
      end
    end

    context 'when the store cannot be determined' do
      before { allow(::Spree::Store).to receive(:current).and_return(nil) }

      it 'raises an error if no store is available' do
        expect do
          described_class.new.perform(product.id, nil)
        end.to raise_error(ActiveRecord::RecordNotFound, /Couldn't find Spree::Store/)
      end
    end

    context 'when the product does not exist' do
      it 'raises an error if the product is not found' do
        invalid_product_id = 9999

        expect do
          described_class.new.perform(invalid_product_id, store.id)
        end.to raise_error(ActiveRecord::RecordNotFound, /Couldn't find Spree::Product/)
      end
    end
  end
end
