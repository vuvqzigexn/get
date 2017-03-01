class Order < ApplicationRecord
  has_many :cart_items
  belongs_to :product
  belongs_to :user
end
