# frozen_string_literal: true

module Spree
  module Admin
    module ProductsControllerDecorator
      def index
        if params[:label_id]
          label = Spree::Label.find(params[:label_id])
          @collection = label.products.page(params[:page]).per(25)
        end
        super
      end

      def destroy
        url = request.referer
        if url&.include?('labels')
          id = url.match(%r{/admin/labels/(\d+)/})[1].to_i
          label = Spree::Label.find(id)
          product = product_scope.friendly.find(params[:id])

          remove_product_from_label(label, product)

          respond_with(product) do |format|
            format.html { redirect_to collection_url }
            format.js { render_js_for_destroy }
          end
        else
          super
        end
      end

      private

      def remove_product_from_label(label, product)
        if label.products.destroy(product)
          flash[:success] = Spree.t('notice_messages.label.product_deleted', label_name: label.name)
        else
          flash[:error] = Spree.t('notice_messages.product_not_deleted', error: product.errors.full_messages.to_sentence)
        end
      rescue ActiveRecord::RecordNotDestroyed => e
        flash[:error] = Spree.t('notice_messages.product_not_deleted', error: e.message)
      end

      def product_params
        params.require(:product).permit(:description, :name, :slug, :discontinue_on, :status, :taxon_id)
      end
    end
  end
end
