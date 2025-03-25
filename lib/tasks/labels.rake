# frozen_string_literal: true

namespace :labels do
  desc 'Destroy all old labels and make active new labels'
  task update_from_queue: :environment do
    today = Time.zone.today

    Spree::Label.where('end_date < ?', today).destroy_all
    Spree::Label.where('start_date = ?', today).find_each { |label| label.update(active: true) }
  end
end
