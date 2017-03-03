class Category < ApplicationRecord
  has_many :products

  def self.lastest_products(category)
    category.products.last(8)
  end
end
