# frozen_string_literal: true

module Spree
  module Admin
    module ProductConcern
      extend ActiveSupport::Concern

      def product_scope
        if params[:label_id]
          label = Spree::Label.find_by(store_id: current_store.id, id: params[:label_id])
          label.products.accessible_by(current_ability, :index).includes(:translations)
        else
          current_store.products.accessible_by(current_ability, :index).includes(:translations)
        end
      end
    end
  end
end
