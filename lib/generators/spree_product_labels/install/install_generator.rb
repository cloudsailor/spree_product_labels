# frozen_string_literal: true

require_relative '../migration_generator'

module SpreeProductLabels
  class InstallGenerator < MigrationGenerator
    MYSQL_ADAPTERS = [
      'ActiveRecord::ConnectionAdapters::MysqlAdapter',
      'ActiveRecord::ConnectionAdapters::Mysql2Adapter'
    ].freeze
    source_root File.expand_path('templates', __dir__)

    desc 'Generates (but does not run) migrations for spree labels'

    def create_migration_files
      add_product_labels_migration('create_spree_labels')
      add_product_labels_migration('create_labels_products')
    end

    private

    def item_type_options
      mysql? ? ', null: false, limit: 191' : ', null: false'
    end

    def mysql?
      MYSQL_ADAPTERS.include?(ActiveRecord::Base.connection.class.name)
    end

    def versions_table_options
      mysql? ? ', options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci"' : ''
    end
  end
end
