# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportProductsJob, type: :job do
  describe '#perform' do
    let!(:label) { create(:label) }
    let!(:first_product) { create(:product, name: 'Product 1') }
    let!(:second_product) { create(:product, name: 'Product 2') }
    let!(:first_variant) { create(:variant, sku: 'SKU123', product: first_product) }
    let!(:second_variant) { create(:variant, sku: 'SKU456', product: second_product) }
    let(:file_path) { 'spec/fixtures/files/sample_import.csv' }

    before do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with(file_path).and_return(true)

      allow(CSV).to receive(:foreach).with(file_path, headers: true).and_yield({ 'sku' => 'SKU123' })
                                     .and_yield({ 'sku' => 'SKU456' })
                                     .and_yield({ 'sku' => 'INVALIDSKU' })

      allow(File).to receive(:delete).with(file_path)
    end

    it 'imports products from the CSV and associates them with the label' do
      expect do
        ImportProductsJob.new.perform(label.id, file_path, 'true')
      end.to change { label.products.count }.by(2)
      expect(label.products).to match_array([first_product, second_product])
      expect(File).to have_received(:delete).with(file_path)
    end
  end
end
