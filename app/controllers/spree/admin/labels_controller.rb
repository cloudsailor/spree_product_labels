# frozen_string_literal: true

module Spree
  module Admin
    class LabelsController < ::Spree::Admin::BaseController
      before_action :set_label, only: %i[edit update destroy new_import import_products]

      def index
        @labels = Spree::Label.where(lang_code: current_store.default_locale).order(:position)
      end

      def new
        @label = Spree::Label.new
      end

      def create
        params[:label][:lang_code] = current_store.default_locale
        @label = Spree::Label.new(label_params)
        if @label.save
          flash[:success] = t('spree.admin.label.created')
          redirect_to admin_labels_path
        else
          flash.now[:alert] = t("flash.actions.#{action_name}.alert")
          render :new, status: :unprocessable_entity
        end
      end

      def edit; end

      def update
        if @label.update(label_params)
          flash[:success] = t('spree.admin.label.updated')
          redirect_to admin_labels_path
        else
          flash.now[:alert] = t("flash.actions.#{action_name}.alert")
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        @label.products&.clear
        @label.destroy
        flash[:success] = t('spree.admin.label.deleted')
        redirect_to admin_labels_path
      end

      def new_import; end

      def import_products
        uploaded_file = params[:import_file]
        @label.products.clear if params[:overwrite] == 'true'
        if uploaded_file.present?
          CSV.foreach(uploaded_file.path, headers: true) do |row|
            sku = row['sku']&.strip
            next unless sku

            variant = ::Spree::Variant.find_by(sku: sku)
            @label.products << variant.product if variant&.product
          end
        end

        redirect_to edit_admin_label_path(@label)
      end

      private

      def set_label
        @label = Spree::Label.find(params[:id])
      end

      def label_params
        params.require(:label).permit(
          :name, :label_type, :position, :active, :start_date, :end_date, :always_active, :lang_code
        )
      end
    end
  end
end
