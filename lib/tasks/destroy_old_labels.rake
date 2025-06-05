# frozen_string_literal: true

namespace :labels do
  desc 'Destroy all old labels and make active new labels'
  task destroy_old: :environment do
    today = Time.zone.today
    if Spree::Label.pluck(:end_date).include?(today)
      puts "Found labels with end_date of #{today}. Proceeding to destroy them."

      labels_count = Spree::Label.where(end_date: today).count
      puts "Number of labels to destroy: #{labels_count}"

      Spree::Label.where(end_date: today).destroy_all
      puts "Successfully destroyed #{labels_count} labels with end_date of #{today}."
    else
      puts "No labels found with end_date of #{today}. No action taken."
    end
  end
end
