class Micropost < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  
  has_many :favorited_relationships, class_name:  "Favorite",
                                     foreign_key: "favoed_id",
                                     dependent:   :destroy
  has_many :favorite_users, through: :favorited_relationships, source: :favo
  
  has_many :retweets, dependent:   :destroy
  has_many :retweet_users, through: :retweets, source: :user
  
  has_many :retweeted_microposts,class_name:'Micropost',
                                 foreign_key: "retweet_id",
                                 dependent:   :destroy
                      
  belongs_to :retweet_micropost,class_name:'Micropost',
                                 foreign_key: "retweet_id"
                        
  
end
