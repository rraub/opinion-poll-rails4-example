class Vote < ActiveRecord::Base
  belongs_to :answer

  validates :answer, presence: true
end
