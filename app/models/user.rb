class User < ActiveRecord::Base
 	before_validation :hash_password
 	attr_accessor :password

	validates :email, 
		presence: true, 
		uniqueness: true, 
		email_format: { message: "doesn't look like an email address" }

	validates :password_digest, presence: true
	validates :password, length: { in: 6..32}, presence: true

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

	protected

	def hash_password
		return unless self.password

    	self.password_salt   = BCrypt::Engine.generate_salt
    	self.password_digest = BCrypt::Engine.hash_secret(@password, self.password_salt)
	end
end
