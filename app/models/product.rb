class Product < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :cart_items
  LASTEST = 8
  PERPAGE = 12

  def get_image
    return if image_url.include?('[')
    image_url
  end

  def price_text
    "$ #{price.to_i/100.0}"
  end
end
