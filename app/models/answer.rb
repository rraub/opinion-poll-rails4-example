class Answer < ActiveRecord::Base
  belongs_to :poll, :dependent => :destroy
  has_many :votes
  
  # validates :poll, presence: true
end
