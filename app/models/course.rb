class Course < ApplicationRecord
  belongs_to :coach

  has_many :activities

  validates :name, presence: true
end
