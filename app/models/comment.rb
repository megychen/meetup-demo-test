class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :meetup
  validates :body, presence: true
end
