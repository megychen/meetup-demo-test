class Meetup < ApplicationRecord
  validates :title, presence: true
end
