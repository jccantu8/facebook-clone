class Post < ApplicationRecord
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :likes
    has_one_attached :picture

    accepts_nested_attributes_for :comments, allow_destroy: true

    validates :title, presence: true, length: { maximum: 255 }
    validates :content, presence: true, length: { maximum: 10000 }
end
