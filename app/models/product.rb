class Product < ApplicationRecord
  belongs_to :category
  has_many :cart_items

  def self.lastest
    self.last(8)
  end
end
