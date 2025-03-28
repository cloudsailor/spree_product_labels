# frozen_string_literal: true

require 'bundler/setup'

APP_RAKEFILE = File.expand_path("#{ENV.fetch('TEST_APP_PATH', nil)}/Rakefile", __dir__)
load 'rails/tasks/engine.rake'

load 'rails/tasks/statistics.rake'

require 'bundler/gem_tasks'
