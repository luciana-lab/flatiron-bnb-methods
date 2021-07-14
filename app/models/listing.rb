class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

  after_create :change_host_status
  after_destroy :host_false

  def change_host_status
    host.host = true
    host.save
  end

  def host_false
    if host.listings.blank?
      host.host = false
      host.save
    end
  end

  def average_review_rating
    #total number of reviews
    #sum of all the review ratings
    #divide those two

    total_sum = 0
    self.reviews.each do |review|
      total_sum += review.rating
    end
    total_sum.to_f / self.reviews.count.to_f
  end

end
