namespace :db do
  desc 'Erase and fill a development database'
  task populate: :environment do
    unless Rails.env.development?
      puts 'db:populate task can only be run in development.'
      exit
    end

    require 'faker/sheltertech'

    [ScheduleDay, Schedule, Phone, Address, Category, Resource].each(&:delete_all)

    %w(Shelter Food Medical Hygiene Technology).each do |category|
      FactoryGirl.create(:category, name: category)
    end
    categories = Category.all

    128.times do
      name = Faker::Company.name
      short_description = Faker::Lorem.sentence if rand(2) == 0
      long_description = Faker::ShelterTech.description
      website = Faker::Internet.url if rand(2) == 0

      FactoryGirl.create(:resource,
                         name: name,
                         short_description: short_description,
                         long_description: long_description,
                         website: website,
                         categories: categories.sample(rand(4)))
    end
  end
end
