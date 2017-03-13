APP = YAML.load_file(Rails.root.join('config', 'application.yml'))
class Product < ApplicationRecord
  belongs_to :category
  belongs_to :user, optional: true
  has_many :cart_items

  LASTEST = 8
  PERPAGE = 12
  MAXROWSEARCH = 2000

  def image
    return APP['DEFAULTIMAGE'] if image_url.include?('[')
    image_url
  end

  def price_text
    "$ #{price.to_i/100.0}"
  end

  def search(query)
    solr = RSolr.connect url: APP['HOSTSOLR']
    query_params = "name:*#{escape_query(query)}*"
    solr.paginate 1, 10,'select', params: {q: query_params, rows: MAXROWSEARCH}
  end

  def escape_query(query)
    APP['ESCAPE'].each_char do |str|
      query = query.gsub(str,'.')
    end
    query.capitalize
  end
end
