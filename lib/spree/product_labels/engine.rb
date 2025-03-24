# frozen_string_literal: true

module Spree
  module ProductLabels
    # Base engine file
    class Engine < ::Rails::Engine
      isolate_namespace Spree::ProductLabels
    end
  end
end
