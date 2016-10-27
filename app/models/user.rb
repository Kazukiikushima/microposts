class User < ActiveRecord::Base
  paginates_per 10
  
    before_save { self.email = self.email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  has_many :microposts
  
  has_many :following_relationships, class_name:  "Relationship",
                                     foreign_key: "follower_id",
                                     dependent:   :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  
  has_many :follower_relationships, class_name:  "Relationship",
                                    foreign_key: "followed_id",
                                    dependent:   :destroy
  has_many :follower_users, through: :follower_relationships, source: :follower
  
   def follow(other_user)
    following_relationships.find_or_create_by(followed_id: other_user.id)
   end

  # フォローしているユーザーをアンフォローする
  def unfollow(other_user)
    following_relationship = following_relationships.find_by(followed_id: other_user.id)
    following_relationship.destroy if following_relationship
  end

  # あるユーザーをフォローしているかどうか？
  def following?(other_user)
    following_users.include?(other_user)
  end
  
  def feed_items
    Micropost.where(user_id: following_user_ids + [self.id])
  end
  
  has_many :favorite_relationships, class_name:  "Favorite",
                                     foreign_key: "favo_id",
                                     dependent:   :destroy
  has_many :favorite_microposts, through: :favorite_relationships, source: :favoed
  
  def favorite(micropost)
    favorite_relationships.find_or_create_by(favoed_id: micropost.id)
  end
  
  def unfavorite(micropost)
    favotite_relationship = favorite_relationships.find_by(favoed_id: micropost.id)
    favorite_relationships.destroy if favotite_relationship
  end

  def favorite?(micropost)
    favorite_microposts.include?(micropost)
  end
  
  has_many :retweets,dependent:   :destroy
  has_many :retweet_microposts, through: :retweets, source: :micropost
  
  def retweeting(micropost)
    retweets.find_or_create_by(micropost_id: micropost.id)
  end

  def unretweeting(micropost)
    retweet = retweets.find_by(micropost_id: micropost.id)
    retweet.destroy if retweet
  end
  
  def retweet_get(other_users)
    @retweets = Retweet.where(user_id: other_users.ids)
    Micropost.where(id: @retweets_ids)
  end

  def retweeting?(micropost)
    retweet_microposts.include?(micropost)
  end
  
  def  retwi(micropost)
    microposts.find_or_create_by(retweet_id: micropost.id, content: micropost.content)
  end 
  
  def  unretwi(micropost)
    if micropost.retweet_id == nil
      retweet = microposts.find_by(retweet_id: micropost.id)
      retweet.destroy
    elsif
      retweet = microposts.find_by(retweet_id: micropost.retweet_id)
      retweet.destroy
    end
  end 
  
  def retwi_micropost(micropost)
      if micropost.retweet_id == nil
      elsif
        Micropost.where(id: micropost.retweet_id)
      end
  end
  
end