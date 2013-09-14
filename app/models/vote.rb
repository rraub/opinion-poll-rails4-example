class Vote < ActiveRecord::Base
  belongs_to :answer

  validates :answer, presence: true

  validate :user_has_not_voted_in_poll

  def user_has_not_voted_in_poll
	self.answer.poll.allowed_to_vote? self.user unless answer.nil?
  end
end
