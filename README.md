# Spree ProductLabels

**Spree ProductLabels** is a plugin to extend Product Labels capabilities.

## Getting Started

Add spree_product_labels to your Gemfile and run bundle install:

```sh
gem 'spree_product_labels'
```

Next, you need to run the generator to create the migrations:

```console
rails generate spree_product_labels:install
```

Then run `rails db:migrate` so the migrations can take effect

```console
rails db:migrate
```

Finally, you need to add a link to the menu in the `config/initializers/spree_admin_menu.rb` file from your application:

```code
if ActiveRecord::Base.connection.data_source_exists?('spree_labels')
   builder_labels = ::Spree::Admin::MainMenu::ItemBuilder.new('admin.tab.labels', '/admin/labels')
   menu_labels = builder_labels.with_match_path('/labels').build
   Rails.application.config.spree_backend.main_menu.add_to_section 'products', menu_labels
end
```

You should restart your application after these updates. Otherwise, you will run into strange errors, for example, route helpers being undefined.
