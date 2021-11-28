require 'rails_helper'

RSpec.describe Activity, type: :model do
  before(:context) do
    @coach = Coach.create(name: 'John')
    @course = Course.create(name: 'Science', self_assignable: true, coach: @coach)
  end

  after(:context) do
    @course.destroy!
    @coach.destroy!
  end

  it "requires the presence of a name" do
    expect(Activity.new).not_to be_valid
  end

  it "requires the presence of a course" do
    expect(Activity.new(name: 'Lab Test')).not_to be_valid
  end

  it "should save the activity" do
    expect(Activity.new(name: 'Lab Test', course: @course)).to be_valid
  end
end
