# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Spree::Label, type: :model do
  describe 'associations' do
    it 'belongs to store' do
      expect(described_class.reflect_on_association(:store).macro).to eq(:belongs_to)
      expect(described_class.reflect_on_association(:store).class_name).to eq('Spree::Store')
    end

    it 'has and belongs to many products' do
      expect(described_class.reflect_on_association(:products).macro).to eq(:has_and_belongs_to_many)
      expect(described_class.reflect_on_association(:products).class_name).to eq('Spree::Product')
    end
  end

  describe 'validations' do
    let(:label) { create(:label) }

    it 'validates presence of name' do
      label.name = nil

      expect(label).to be_invalid
      expect(label.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of label_type' do
      label.label_type = nil

      expect(label).to be_invalid
      expect(label.errors[:label_type]).to include("can't be blank")
    end

    context 'custom validations' do
      let!(:store) { create(:store) }

      describe '#end_date_after_start_date' do
        it 'adds error when end_date is before start_date' do
          label = build(:label, store: store, start_date: Time.zone.today, end_date: Date.yesterday)

          expect(label).to be_invalid
          expect(label.errors[:end_date]).to be_present
        end

        it 'is valid when end_date is after start_date' do
          label = build(:label, store: store, start_date: Time.zone.today, end_date: Date.tomorrow)

          expect(label).to be_valid
        end
      end

      describe '#only_one_active_label_per_priority' do
        let!(:existing_label) { create(:label, store: store, active: true, position: 1, label_type: 'promo') }

        it 'adds error if another active label with same position exists in same store' do
          new_label = build(:label, store: store, active: true, position: 1, label_type: 'promo')

          expect(new_label).to be_invalid
          expect(new_label.errors[:position]).to be_present
        end
      end

      describe '#only_one_active_label_per_type' do
        let!(:existing_label) { create(:label, store: store, active: true, label_type: 'promo') }

        it 'adds error if another active label with same type exists in same store' do
          new_label = build(:label, store: store, active: true, label_type: 'promo')

          expect(new_label).to be_invalid
          expect(new_label.errors[:base]).to include(Spree.t('admin.label.validates.only_one_active_label_per_type'))
        end
      end

      describe '#no_overlapping_validity_dates' do
        let!(:existing_label) do
          create(:label, store: store, active: true, label_type: 'promo', start_date: Time.zone.today,
                         end_date: Time.zone.today + 5.days)
        end

        it 'adds error when validity dates overlap with existing label' do
          overlapping_label = build(:label, store: store, label_type: 'promo',
                                            start_date: Time.zone.today + 2.days, end_date: Time.zone.today + 10.days)

          expect(overlapping_label).to be_invalid
          expect(overlapping_label.errors[:base]).to include(Spree.t('admin.label.validates.no_overlapping_validity_dates'))
        end
      end

      describe '#validate_color_format' do
        context 'when color is valid' do
          it 'with a valid hex color code' do
            label = build(:label, color: '#FF0000')

            expect(label).to be_valid
          end

          it 'with a valid shorthand hex color code' do
            label = build(:label, color: '#F00')

            expect(label).to be_valid
          end
        end

        context 'when color is invalid' do
          it 'with an invalid hex color code' do
            label = build(:label, color: 'invalid_color')

            expect(label).to be_invalid
            expect(label.errors[:color]).to include(Spree.t('admin.label.validates.color_format'))
          end

          it 'with a color code missing the hash symbol' do
            label = build(:label, color: 'FF0000')

            expect(label).to be_invalid
            expect(label.errors[:color]).to include(Spree.t('admin.label.validates.color_format'))
          end

          it 'with a color code that is too short' do
            label = build(:label, color: '#FF')

            expect(label).to be_invalid
            expect(label.errors[:color]).to include(Spree.t('admin.label.validates.color_format'))
          end

          it 'with a color code that is too long' do
            label = build(:label, color: '#FFFFFFFF')

            expect(label).to be_invalid
            expect(label.errors[:color]).to include(Spree.t('admin.label.validates.color_format'))
          end
        end
      end
    end
  end

  describe '#always_active' do
    it 'returns true if end_date is nil' do
      label = build(:label, end_date: nil)

      expect(label.always_active).to eq(true)
    end

    it 'returns false if end_date is set' do
      label = build(:label, end_date: Time.zone.today)

      expect(label.always_active).to eq(false)
    end
  end

  describe '#capitalize_label_type' do
    it 'capitalizes label_type before validation' do
      label = build(:label, label_type: 'test type')

      expect(label).to be_valid
      expect(label.label_type).to eq('Test type')
    end

    it 'does not change label_type if it is already capitalized' do
      label = build(:label, label_type: 'Test type')

      expect(label).to be_valid
      expect(label.label_type).to eq('Test type')
    end

    it 'handles nil label_type gracefully' do
      label = build(:label, label_type: nil)

      expect(label).to be_invalid
      expect(label.label_type).to be_nil
    end
  end
end
