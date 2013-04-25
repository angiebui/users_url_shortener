require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  has_many :urls
  validates :email, :uniqueness => true, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :name, :presence => true
  validates :password, :presence => true


  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def self.authenticate(email, password) 
    user = User.where("email = ?", email).first
    if user && user.password == password
      user 
    else
      nil  
    end
  end
end
