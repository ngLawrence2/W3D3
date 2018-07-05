# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint(8)        not null, primary key
#  user_id    :integer          not null
#  long_url   :string           not null
#  short_url  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ShortenedUrl < ActiveRecord::Base
  include SecureRandom
  validates :long_url, :short_url, presence: true, uniqueness: true
  validates :user_id, presence: true
  
  belongs_to :submitter,
    class_name: :User,
    primary_key: :id,
    foreign_key: :user_id
    
  has_many :visits,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :Visit
    
  has_many :visitors,
    ->{ distinct }, through: :visits, source: :visitor
    
  def create!
    self.short_url = ShortenedUrl.random_code
    self.save
  end 
  
  def num_clicks
    visits.count
  end 
  
  def num_uniques
    visitors.count
  end
  
  def num_recent_uniques
    visits.select { |v| (((Time.now - v.created_at) / 60 ) < 10)}.count
  end 

  def self.random_code
    # raise "already shortened" if self.short_url
    short = SecureRandom.urlsafe_base64(16, false)
    while ShortenedUrl.exists?(:short_url => short)
      short = SecureRandom.urlsafe_base64(16, false)
    end
    short
  end
end