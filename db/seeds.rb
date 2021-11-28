# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

6.times do
  coach = Coach.create(name: Faker::Name.unique.name)
  4.times do
    course = Course.create({
                            name: Faker::Educator.unique.course_name,
                            self_assignable: Faker::Boolean.boolean(true_ratio: 0.5),
                            coach_id: coach.id
                          })
    2.times do
      Activity.create(name: Faker::Hobby.unique.activity, course_id: course.id)
    end
  end
end