# frozen_string_literal: true

namespace :labels do
  desc 'Make active new labels'
  task make_active: :environment do
    today = Time.zone.today
    if Spree::Label.pluck(:start_date).include?(today)
      puts "Found labels with start_date of #{today}. Proceeding to activate them."

      labels_count = Spree::Label.where(start_date: today).count
      puts "Number of labels to activate: #{labels_count}"

      Spree::Label.where(start_date: today).find_each do |label|
        if label.update(active: true)
          puts "Successfully activated label with name: #{label.name} and start_date of #{today}."
        else
          label.errors.full_messages.each { |message| puts "Validation error for label ID #{label.id}: #{message}" }
        end
      end
    else
      puts "No labels found with start_date of #{today}. No action taken."
    end
  end
end
