# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Spree::Admin::LabelsController, type: :controller do
  stub_authorization!

  let(:store) { create(:store) }
  let(:label) { create(:label, store: store) }
  let(:valid_attributes) { attributes_for(:label, store_id: store.id) }
  let(:invalid_attributes) { { name: '' } }

  before do
    file_path = Rails.root.join('spec/fixtures/files/sample_import.csv')
    FileUtils.mkdir_p(file_path.dirname) unless Dir.exist?(file_path.dirname)

    File.open(file_path, 'w') do |file|
      file.puts 'product_sku,product_name'
      file.puts 'SKU123,Product Name 1'
      file.puts 'SKU456,Product Name 2'
    end
  end

  after { FileUtils.rm_rf(Rails.root.join('spec/fixtures')) if Dir.exist?(Rails.root.join('spec/fixtures')) }

  describe 'GET #index' do
    it 'assigns labels belonging to current store' do
      get :index

      expect(response).to be_successful
      expect(response.content_type).to eq 'text/html; charset=utf-8'
      expect(response).to render_template('index')
    end
  end

  describe 'GET #new' do
    it 'assigns a new label' do
      get :new

      expect(response).to be_successful
      expect(assigns(:label)).to be_a_new(Spree::Label)
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Label' do
        expect { post :create, params: { label: valid_attributes } }.to change(Spree::Label, :count).by(1)
        expect(response).to redirect_to(admin_labels_path)
        expect(flash[:success]).to eq(I18n.t('spree.admin.label.created'))
      end
    end

    context 'with invalid params' do
      it 'renders the new template' do
        post :create, params: { label: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested label' do
      get :edit, params: { id: label.id }

      expect(assigns(:label)).to eq(label)
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      it 'updates the label' do
        patch :update, params: { id: label.id, label: { name: 'Updated Name', label_type: 'New' } }
        label.reload

        expect(label.name).to eq('Updated Name')
        expect(response).to redirect_to(admin_labels_path)
        expect(flash[:success]).to eq(I18n.t('spree.admin.label.updated'))
      end
    end

    context 'with invalid params' do
      it 'renders the edit template' do
        patch :update, params: { id: label.id, label: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested label' do
      delete :destroy, params: { id: label.id }

      expect(Spree::Label.count).to eq 0
      expect(response).to redirect_to(admin_labels_path)
      expect(flash[:success]).to eq(I18n.t('spree.admin.label.deleted'))
    end
  end

  describe 'GET #new_import' do
    it 'renders the new_import template' do
      get :new_import, params: { id: label.id }

      expect(response).to be_successful
    end
  end

  describe 'POST #import_products' do
    let(:file) { fixture_file_upload('sample_import.csv', 'text/csv') }

    context 'when file is provided' do
      it 'enqueues ImportProductsJob' do
        post :import_products, params: { id: label.id, import_file: file }

        expect(response).to redirect_to(edit_admin_label_path(label))
        expect(flash[:notice]).to eq(I18n.t('flash.actions.import.success'))
      end
    end

    context 'when file is missing' do
      it 'redirects back with error' do
        post :import_products, params: { id: label.id }

        expect(response).to redirect_to(edit_admin_label_path(label))
        expect(flash[:error]).to eq(I18n.t('flash.actions.import.file_not_found'))
      end
    end
  end

  describe 'security checks in set_label' do
    it 'redirects if label not found' do
      get :edit, params: { id: 9999 }

      expect(response).to redirect_to(admin_labels_path)
      expect(flash[:alert]).to eq(I18n.t('spree.admin.label.not_found'))
    end
  end
end
