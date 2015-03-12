class LectureBook < ActiveRecord::Base
  belongs_to :lecture
  belongs_to :book
end
