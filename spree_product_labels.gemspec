# frozen_string_literal: true

require_relative 'lib/spree/product_labels/version'

Gem::Specification.new do |spec|
  spec.name = 'spree_product_labels'
  spec.version = Spree::ProductLabels::VERSION
  spec.authors = ['Vitalii Cherednichenko']
  spec.email = ['vitalii.cherednichenko@yes.pl']

  spec.summary = 'Product listing labels'
  spec.homepage = 'https://github.com/cloudsailor/spree_product_labels'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.3.0'

  spec.metadata['allowed_push_host'] = 'http://rubygems.org/'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/cloudsailor/spree_product_labels'
  spec.metadata['changelog_uri'] = 'https://github.com/cloudsailor/spree_product_labels/CHANGELOG.md'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .travis appveyor Gemfile])
    end
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'pg'
  spec.add_dependency 'rails'
  spec.add_dependency 'spree'
  spec.add_dependency 'spree_backend'
  spec.add_dependency 'spree_i18n'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
