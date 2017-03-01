class Product < ApplicationRecord
  has_many :post
  has_many :cart
end