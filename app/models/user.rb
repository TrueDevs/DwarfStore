class User < ActiveRecord::Base
 	before_validation :hash_password
 	attr_accessor :password

	validates :email, 
		presence: true, 
		uniqueness: true, 
		email_format: { message: "doesn't look like an email address" }

	validates :password_digest, presence: true
	validates :password, length: { in: 6..32}, if: :check_password?

	has_many :banned_user, class_name: 'User', foreign_key: 'banned_by_id'
	belongs_to :banned_by, class_name: 'User'

	#auth and token
	def self.auth(email, password)
		u = User.find_by(email: email)
		return u if u && u.auth(password)
	end

	def auth(password) 
		self.password_digest == BCrypt::Engine.hash_secret(password, self.password_salt)
	end

	def token!
		generate_token!	unless self.auth_token
		self.auth_token
	end

	def generate_token!
		self.auth_token = "#{self.id}::#{SecureRandom.hex}"
		save!
	end

	def clear_token!
		self.auth_token = nil
		save!
	end

	#permissions
	def user_rights
		return 'Super user' if super_user?
		return 'Moderator' if moderator?
		return 'Saller' if saller?
		return 'User'
	end

	def super_user?
		role > 2
	end

	def moderator?
		role > 1
	end

	def saller?
		role > 0
	end

	#ban
	def ban_user(super_user)
		return false until super_user.super_user? || banned

		self.banned = true
		self.banned_by = super_user
		self.banned_date = Time.now
		save

		return true
	end

	def clear_ban(super_user)
		return false until super_user.super_user? || !banned

		self.banned = false
		save

		return true
	end

	protected

	def check_password?
		@password.present?
	end

	def hash_password
		return unless self.password

    	self.password_salt   = BCrypt::Engine.generate_salt
    	self.password_digest = BCrypt::Engine.hash_secret(@password, self.password_salt)
	end
end
