class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable, :lockable, :jwt_authenticatable, jwt_revocation_strategy: self

  def json_representation
    attributes.slice("id", "email", "name", "jti")
  end

  validates :name, presence: true
end
