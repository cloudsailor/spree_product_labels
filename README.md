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

You should restart your application after these updates. Otherwise, you will run into strange errors, for example, route helpers being undefined.
