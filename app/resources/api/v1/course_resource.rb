module Api::V1
  class CourseResource < JSONAPI::Resource
    attributes :name, :self_assignable

    has_one :coach
    has_many :activities

    filter :self_assignable
  end
end
