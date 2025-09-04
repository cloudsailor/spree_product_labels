# frozen_string_literal: true

namespace :labels do
  desc 'Make active new labels'
  task make_active: :environment do
    today = Time.zone.today
    labels_to_activate = Spree::Label.where(start_date: today)
    labels_count = labels_to_activate.count
    if labels_count.positive?
      puts "Found labels with start_date of #{today}. Proceeding to activate them."
      puts "Number of labels to activate: #{labels_count}"
      labels_to_activate.find_each do |label|
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
