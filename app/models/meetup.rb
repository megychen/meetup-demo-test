class Meetup < ApplicationRecord
  validates :title, presence: true
  belongs_to :user
  has_many :comments, dependent: :destroy

  def self.no_description
    where(:description => nil)
  end

  def abstract
    self.description[0..20]
  end
end
