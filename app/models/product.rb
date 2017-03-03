class Product < ApplicationRecord
  belongs_to :category
  has_many :cart_items
  LASTEST = 8
  PERPAGE = 12
end
