class Product < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :cart_items

  LASTEST = 8
  PERPAGE = 12

  def image
    return if image_url.include?('[')
    image_url
  end

  def price_text
    "$ #{price.to_i/100.0}"
  end

  def search(query)
    sorl = RSolr.connect url: 'http://localhost:9000/solr/venshop_v2'
    query_params = "name:*#{query.capitalize}*"
    sorl.get 'select', params: {q: query_params}
  end
end
