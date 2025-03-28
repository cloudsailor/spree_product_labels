# frozen_string_literal: true

class ImportProductsJob
  include Sidekiq::Worker

  def perform(label_id, file_path, overwrite)
    label = Spree::Label.find_by(id: label_id)
    return unless label
    return unless File.exist?(file_path)

    label.products.clear if overwrite == 'true'

    CSV.foreach(file_path, headers: true) do |row|
      sku = row['sku']&.strip
      next if sku.blank?

      variant = ::Spree::Variant.find_by(sku: sku)
      label.products << variant.product if variant&.product
    end

    label.save!
  rescue StandardError => e
    Rails.logger.error("Failed to import products for label ID: #{label_id}. Error: #{e.message}")
  ensure
    File.delete(file_path) if File.exist?(file_path)
  end
end
