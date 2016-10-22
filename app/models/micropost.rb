class Micropost < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  
  has_many :favorited_relationships, class_name:  "Favorite",
                                     foreign_key: "favoed_id",
                                     dependent:   :destroy
  has_many :favorite_users, through: :favorited_relationships, source: :favo
  
end
