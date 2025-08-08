class CoursePackage < ApplicationRecord
  belongs_to :course
  belongs_to :package

  def self.ransackable_associations(auth_object = nil)
    ["course", "package"]
  end
end
