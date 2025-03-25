# frozen_string_literal: true

module SpreeProductLabels
  class Engine < Rails::Engine
    require 'spree/core'
    require 'deface'

    engine_name 'spree_product_labels'
    isolate_namespace SpreeProductLabels
    config.autoload_paths += %W[#{config.root}/lib]

    def self.activate
      if frontend_available?
        Dir.glob(File.join(File.dirname(__FILE__), '../../app/overrides/*.rb')) do |c|
          Rails.application.config.cache_classes ? require(c) : load(c)
        end
      end

      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    def self.frontend_available?
      @frontend_available ||= ::Rails::Engine.subclasses.map(&:instance).map do |e|
        e.class.to_s
      end.include?('Spree::Frontend::Engine')
    end

    config.to_prepare &method(:activate).to_proc
  end
end
