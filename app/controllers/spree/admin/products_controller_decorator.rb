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

      private

      def product_params
        params.require(:product).permit(:description, :name, :slug, :discontinue_on, :status, :taxon_id)
      end
    end
  end
end
