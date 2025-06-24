# frozen_string_literal: true

namespace :labels do
  desc 'Destroy all old labels and make active new labels'
  task destroy_old: :environment do
    today = Time.zone.today

    old_labels = Spree::Label.where('end_date < ?', today)
    labels_count = old_labels.count

    if labels_count > 0
      puts "Found #{labels_count} labels with end_date before #{today}. Proceeding to destroy them."
      old_labels.destroy_all
      puts "Successfully destroyed #{labels_count} labels with end_date before #{today}."
    else
      puts "No labels found with end_date before #{today}. No action taken."
    end
  end
end
