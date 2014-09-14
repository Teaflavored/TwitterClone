class Micropost < ActiveRecord::Base
	belongs_to :user
  before_create :micropost_extract_username
  
	default_scope -> { order('created_at DESC') }
  
  #need scope to include all the replies
  
	validates :content, presence: true, length: {maximum: 140}
	validates :user_id, presence: true
  
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                             WHERE follower_id = :user_id"
        where("(user_id IN (#{followed_user_ids}) AND (reply_to = :user_id OR reply_to IS NULL)) OR user_id = :user_id OR reply_to = :user_id",
              user_id: user.id)
  end
  
  private
  
    def micropost_extract_username
      message = self.content
      start=ending=nil
      if message.match(/\A@/)
        start=message.index(/@/)+1
        ending=message.index(/\W/,1)-1 if message.index(/\W/,1)!=nil
      end
      return nil if start.nil? || ending.nil?
      username = message[start..ending]
      user_from_extraction = User.find_by(username: username)
      self.reply_to = user_from_extraction.id if user_from_extraction
    end
end
