require 'rails_helper'
require 'faker'

RSpec.describe Coach, type: :model do
  it "requires the presence of a name" do
    expect(Coach.new).not_to be_valid
  end

  it "should expect the coach to be valid" do
    expect(Coach.new(name: 'John')).to be_valid
  end

  it "reassign courses to other coach" do
    coach1 = Coach.create(name: Faker::Name.unique.name)
    coach2 = Coach.create(name: Faker::Name.unique.name)
    2.times do
      course = Course.create({
                              name: Faker::Educator.unique.course_name,
                              self_assignable: Faker::Boolean.boolean(true_ratio: 0.5),
                              coach_id: coach1.id
                            })
    end
    courses = coach1.courses
    course_ids = courses.map(&:id)

    expect(courses.length).to eq(2)
    expect(courses.first.coach_id).to eq(coach1.id)

    coach1.destroy
    courses = Course.where(id: course_ids)

    expect(Coach.count).to eq(1)
    expect(courses.length).to eq(2)
    expect(courses.first.coach_id).to eq(coach2.id)
  end
end
