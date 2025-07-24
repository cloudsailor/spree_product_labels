# frozen_string_literal: true

module Spree
  module Admin
    class LabelsController < ::Spree::Admin::BaseController
      before_action :set_label, only: %i[edit update destroy new_import import_products label_products destroy_product]

      def index
        @labels = Spree::Label.where(store_id: current_store.id).order(:position)
      end

      def new
        @label = Spree::Label.new
      end

      def create
        @label = Spree::Label.new(label_params.merge(label_type:))
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
        if @label.update(label_params.merge(label_type:))
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
        if uploaded_file.blank?
          flash[:error] = t('flash.actions.import.file_not_found')
          return redirect_to edit_admin_label_path(@label)
        end

        temp_file_path = save_to_tmp_folder(uploaded_file)
        ImportProductsJob.perform_async(@label.id, temp_file_path, params[:overwrite])
        flash[:notice] = t('flash.actions.import.success')
        redirect_to edit_admin_label_path(@label)
      end

      def label_products
        @collection = @label.products.page(params[:page]).per(25)
      end

      def destroy_product
        product = Spree::Product.find_by(id: params[:product_id])
        if @label.products.destroy(product)
          flash[:success] = Spree.t('notice_messages.label.product_deleted', label_name: @label.name)
        else
          flash[:error] = Spree.t('notice_messages.product_not_deleted', error: product.errors.full_messages.to_sentence)
        end
        redirect_to label_products_admin_label_path(@label)
      end

      private

      def save_to_tmp_folder(file)
        file_name = "import_#{SecureRandom.uuid}_#{file.original_filename}"
        file_path = Rails.root.join('tmp', 'uploads', file_name)
        FileUtils.mkdir_p(file_path.dirname) unless Dir.exist?(file_path.dirname)
        File.open(file_path, 'wb') { |f| f.write(file.read) }
        file_path.to_s
      end

      def set_label
        return if params[:id].blank?

        @label = Spree::Label.find_by(id: params[:id])
        redirect_to(admin_labels_path, alert: t('spree.admin.label.not_found')) and return if @label.nil?

        return unless @label.store_id != current_store.id

        flash[:error] = t('spree.admin.label.not_found_in_current_store')
        redirect_to admin_labels_path and return
      end

      def label_type
        if params[:label][:label_type] == 'other'
          params[:label][:custom_label_type].presence
        else
          params[:label][:label_type]
        end
      end

      def label_params
        params.require(:label).permit(
          :name, :label_type, :position, :active, :start_date, :end_date, :store_id, :color, :description
        )
      end
    end
  end
end
