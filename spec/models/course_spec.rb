require 'rails_helper'

RSpec.describe Course, type: :model do
  before(:context) do
    @coach = Coach.create(name: 'John')
  end

  after(:context) do
    @coach.destroy
  end

  it "requires the presence of a name" do
    expect(Course.new).not_to be_valid
  end

  it "requires the presence of a coach" do
    expect(Course.new(name: 'Science')).not_to be_valid
  end

  it "should save the course" do
    expect(Course.new(name: 'Science', coach: @coach)).to be_valid
  end
end
