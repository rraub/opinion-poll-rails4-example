class Vote < ActiveRecord::Base
  belongs_to :answer

  validates :answer, presence: true

  validate :user_allowed_to_vote
  # todo, user not empty

  def user_allowed_to_vote
  	return false if answer.nil? 
	  unless self.answer.poll.allowed_to_vote?(self.user)
	    errors.add(:user, "Only one vote per user")
	    return false
	  end
  end
end
