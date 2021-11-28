require 'rails_helper'
require 'faker'

RSpec.describe "Api::V1::Courses", type: :request do
  describe "GET /index" do
    before(:context) do
      @coach = Coach.create(name: 'John')
      2.times { Course.create(name: Faker::Educator.unique.course_name, coach: @coach) }
    end

    after(:context) do
      Course.destroy_all
      @coach.destroy
    end

    before(:example) do
      get api_v1_courses_path
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "JSON body response contains expected course attributes" do
      json_response = JSON.parse(response.body)
      attributes = json_response.dig('data', 0, 'attributes')
      associations = json_response.dig('data', 0, 'relationships')

      expect(json_response['data'].length).to eq(2)
      expect(attributes.keys).to match_array(['name', 'self-assignable'])
      expect(associations.keys).to match_array(['coach', 'activities'])
    end
  end

  describe "GET /show" do
    before(:context) do
      @coach = Coach.create(name: 'John')
      2.times { Course.create(name: Faker::Educator.unique.course_name, coach: @coach) }
      @course = Course.first
    end

    after(:context) do
      Course.destroy_all
      @coach.destroy
    end

    before(:example) do
      get api_v1_course_path(id: @course.id)
    end

    it "should return error for no matching course" do
      get api_v1_course_path(id: 1000)
      expect(response).to have_http_status(:not_found)
      json_response = JSON.parse(response.body)
      expect(json_response.dig('errors', 0, 'title')).to eq('Record not found')
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "JSON body response matches expected course" do
      json_response = JSON.parse(response.body)
      attributes = json_response.dig('data', 'attributes')
      associations = json_response.dig('data', 'relationships')

      expect(json_response.dig('data', 'id')).to eq(@course.id.to_s)
      expect(attributes.keys).to match_array(['name', 'self-assignable'])
      expect(associations.keys).to match_array(['coach', 'activities'])
    end
  end

  describe "POST /create" do
    before(:context) do
      @coach = Coach.create(name: 'John')
    end

    after(:context) do
      @coach.destroy
    end

    before(:example) do
      @payload = {
        "data": {
          "type": "courses",
          "relationships": {
            "coach": { "data": { "type": "coaches", "id": @coach.id } }
          },
          "attributes": {
            "name": "Data Science",
            "self-assignable": true
          }
        }
      }
      @headers = { "Content-Type": "application/vnd.api+json" }
    end

    it "should return error for missing name attribute" do
      @payload.dig(:data, :attributes).delete(:name)
      post api_v1_courses_path(@payload), headers: @headers

      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response.dig('errors', 0, 'detail')).to eq("name - can't be blank")
    end

    it "should return error for missing the coach association" do
      @payload.dig(:data, :relationships).delete(:coach)
      post api_v1_courses_path(@payload), headers: @headers

      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response.dig('errors', 0, 'detail')).to eq('coach - must exist')
    end

    it "should save the course" do
      post api_v1_courses_path(@payload), headers: @headers
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      course = Course.find(json_response.dig('data', 'id'))
      expect(course.name).to eq('Data Science')
      expect(course.coach_id).to eq(@coach.id)
    end
  end
end
