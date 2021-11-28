module Api::V1
  class ActivityResource < JSONAPI::Resource
    attributes :name

    has_one :course
  end
end
