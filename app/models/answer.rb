class Answer < ActiveRecord::Base
  belongs_to :poll
  has_many :votes
  
  validates :poll, presence: true
end
