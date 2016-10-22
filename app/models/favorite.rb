class Favorite < ActiveRecord::Base
  belongs_to :favo, class_name: "User"
  belongs_to :favoed, class_name: "Micropost"
end
