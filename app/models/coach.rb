class Coach < ApplicationRecord
  has_many :courses

  validates :name, presence: true

  before_destroy :reassign_courses

  private

  def reassign_courses
    coach_courses = courses
    return if courses.blank?

    coaches = Coach.where.not(id: id).pluck(:id)
    random_coach = coaches[rand(coaches.length)]
    coach_courses.update_all(coach_id: random_coach)
  end
end
