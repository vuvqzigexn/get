CONFIG = YAML.load_file("#{Rails.root}/config/task_product.yml")
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
  
  def import(sites)
    (1..sites.to_i).each do |page|
      get_response(page).each do |item| 
        next if (attributes = item["ItemAttributes"]).nil?

        begin
          category = Category.find_or_create_by(name: attributes["ProductGroup"])
          product_name = attributes.to_h["Title"]

          price = if attributes["ListPrice"].present?
                    attributes["ListPrice"]["Amount"].to_i
                  elsif item["OfferSummary"].present? and  \
                    item["OfferSummary"]['LowestNewPrice'].present?
                    item["OfferSummary"]['LowestNewPrice']['Amount'].to_i
                  end
          next if !price

          image = if item["LargeImage"]
                    item["LargeImage"]["URL"]
                  elsif item["ImageSets"].present? and
                    item["ImageSets"]['ImageSet'].map {|img| img["LargeImage"]["URL"]}
                  end
          next if !image

          product = Product.find_or_create_by( 
                      name: product_name,
                      image_url: image.to_s,
                      price: price,
                      origin: item['DetailPageURL'],
                      description: valid_description(item),
                      category_id: category.id
              )
          puts "[Import success]  #{product.name}" if product.save
        rescue Exception => e
          puts e
        end
      end
    end
  end

  private

  def valid_description(item)
    des = item["EditorialReviews"]
    return des["EditorialReview"]["Content"] if des.present? \
      and (review = des["EditorialReview"]).present? \
      and !review.kind_of?(Array) and review["Content"].present?
    return des["EditorialReview"][0]["Content"] if des.present? \
      and des["EditorialReview"][0]["Content"].present?
    des = "This is default description"
  end

  def get_response(page)
    response = @request.item_search(
      query: {
        'Keywords' => '*',
        'SearchIndex' => 'Blended',
        'ResponseGroup' => 'Medium',
        'ItemPage' => page,
        }
      )
    response = response.to_h["ItemSearchResponse"]["Items"]["Item"] || {}
  end

end