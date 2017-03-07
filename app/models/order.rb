class Order < ApplicationRecord
  has_many :cart_items
  belongs_to :user, optional: true
  belongs_to :status
end
