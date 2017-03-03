CONFIG = YAML.load_file(Rails.root.join('config', 'task_product.yml'))
AWS_ACCESS_KEY_ID = CONFIG['aws_access_key_id']
AWS_SECRET_KEY = CONFIG['aws_secret_access_key']
ASSOCIATETAG = CONFIG['associate_tag']

class Worker
  def initialize
    @request = Vacuum.new('US')
    @request.configure(
      aws_access_key_id: AWS_ACCESS_KEY_ID,
      aws_secret_access_key: AWS_SECRET_KEY,
      associate_tag: ASSOCIATETAG
    )

    @request.associate_tag = 'tag'
  end

  def import
    (1..10).each do |page|
      get_response(page).each do |item|
        next if (attributes = item["ItemAttributes"]).nil?
        category = Category.find_or_create_by(name: attributes['ProductGroup'])
        begin
          product_name = attributes.to_h['Title']
          if attributes['ListPrice'].present?
            price = attributes['ListPrice']['Amount'].to_i
          elsif (offer = item['OfferSummary']).present? && offer['LowestNewPrice'].present?
            price = offer['LowestNewPrice']['Amount'].to_i
          end
          next unless price
          if item['LargeImage']
            image = item['LargeImage']['URL']
          elsif (image_sets = item['ImageSets']).present? && image_sets['ImageSet'].present?
            image = image_sets['ImageSet'].map {|img| img['LargeImage']['URL']}
          end
          next unless image
          Product.find_or_create_by(
            name: product_name,
            image_url: image.to_s,
            price: price,
            origin: item['DetailPageURL'],
            description: valid_description(item),
            category_id: category.id,
            stock: Random.new.rand(5..30)
          )
          # puts "[Import success]  #{product.name}" if product.save
        rescue StandardError?
          # puts e
        end
      end
    end
  end

  private


  def valid_description(item)
    des = item["EditorialReviews"]
    return des["EditorialReview"]["Content"] if des.present? \
      && (review = des["EditorialReview"]).present? \
      && !review.is_a?(Array) && review["Content"].present?
    return des["EditorialReview"][0]["Content"] if des.present? \
      && des["EditorialReview"][0]["Content"].present?
    return "This is default description"
  end

  def get_response(page)
    query = {
        Keywords: '*',
        SearchIndex: 'Blended',
        ResponseGroup: 'Medium',
        ItemPage: page
      }
    @request.item_search(query: query).to_h["ItemSearchResponse"]["Items"]["Item"] || {}
  end
end
