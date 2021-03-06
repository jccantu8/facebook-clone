class User < ApplicationRecord
  before_save { self.email = self.email.downcase }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :sent_friend_requests, foreign_key: "requestor_id", class_name: "FriendRequest"
  has_many :received_friend_requests, foreign_key: "requestee_id", class_name: "FriendRequest"
  has_many :friends
  has_many :likes
  has_one_attached :avatar

  validates :name, presence: true, length: { maximum: 30 },
    format: { with: /\A[a-zA-Z]+\z/,
              message: "Names can only contain letters" }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false },
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, 
              message: "Emails can only contain certain characters" }
  validates :password, presence: true, length: { maximum: 30 }
  validates :password_confirmation, presence: true, length: { maximum: 30 }
  #add validation for about_me

end