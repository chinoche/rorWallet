class User < ApplicationRecord
  has_secure_password

  # Associate with transaction
  has_many :transactions, foreign_key: :created_by

  validates_presence_of :username, :email, :password_digest, :balance
end
