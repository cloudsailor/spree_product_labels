# frozen_string_literal: true

namespace :labels do
  desc 'Destroy all old labels and make active new labels'
  task destroy_old: :environment do
    today = Time.zone.today
    start_date = today - 7.days

    (start_date..today).each do |date|
      if Spree::Label.pluck(:end_date).include?(date)
        puts "Found labels with end_date of #{date}. Proceeding to destroy them."

        labels_count = Spree::Label.where(end_date: date).count
        puts "Number of labels to destroy: #{labels_count}"

        Spree::Label.where(end_date: date).destroy_all
        puts "Successfully destroyed #{labels_count} labels with end_date of #{date}."
      else
        puts "No labels found with end_date of #{date}. No action taken."
      end
    end
  end
end
