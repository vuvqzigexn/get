namespace :product do
  desc "GET ALL PRODUCTS FROM AMAZON"
  task get_all: :environment do
    Worker.new.import
  end
end
