
class UsernameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || "must contain only letters and number") unless
      value =~ /\A[a-z0-9]+\z/i
  end
end

class User < ActiveRecord::Base
	before_create :create_remember_token
	has_many :microposts, dependent: :destroy
  
  #followed_users array
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  
  #followers array
  has_many :reverse_relationships, foreign_key: "followed_id",
                                     class_name:  "Relationship"
  has_many :followers, through: :reverse_relationships, source: :follower
  
  
  
	before_save { self.email = email.downcase }
  before_save { self.username = username.downcase }
  
	has_secure_password
	validates :password, length: {minimum: 6}
	validates :name, presence: true, length: {maximum: 50}
  validates :username, presence: true, uniqueness: {case_sensitive: false}, 
            length: { minimum: 4, maximum: 16 }, username: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.digest(token)
		Digest::SHA1.hexdigest(token.to_s)
	end
  
  def send_password_reset
    self.update_attribute(:password_reset_token,User.new_remember_token)
    self.update_attribute(:password_reset_sent_at, Time.zone.now)
    Usermailer.password_reset(self).deliver
  end
  
  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    return true if self.followed_users.include?(other_user)
    #returns true if self is following the other_user
  end
  
  def followed?(other_user)
    #returns true if other_user is following self
    return true if other_user.followed_users.include?(self)
  end
  
  def self.search(search)
    find(:all, conditions: ['name ILIKE ?', "%#{search}%"])
  end
  
  def follow!(other_user)
    self.relationships.create!(followed_id: other_user.id)
  end
  
  def unfollow!(other_user)
    self.relationships.find_by(followed_id: other_user.id).destroy
  end
  
	private
		def create_remember_token
			self.remember_token = User.digest(User.new_remember_token)
		end
end
