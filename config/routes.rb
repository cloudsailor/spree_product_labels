# frozen_string_literal: true

Spree::Core::Engine.add_routes do
  namespace :admin, path: Spree.admin_path do
    resources :labels do
      member do
        get :new_import
        post :import_products
      end
    end
  end
end
