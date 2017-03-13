class Order < ApplicationRecord
  before_validation :default_status
  has_many :cart_items
  belongs_to :user, optional: true
  belongs_to :status


  private
  def default_status
    self.status = Status.find_by(name: 'New')
  end
end
