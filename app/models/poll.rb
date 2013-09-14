class Poll < ActiveRecord::Base
  has_many :answers
  has_many :votes, :through => :answers
  
  validate :has_minium_answers, :has_less_than_or_equal_to_the_maximum_answers

  MIN_ANSWERS = 2
  MAX_ANSWERS = 5

  def has_minium_answers
  	if answers.nil? or answers.length < MIN_ANSWERS
  	  errors.add(:answers, "not enough, minium of #{MIN_ANSWERS}") 
  	end
  end

  def has_less_than_or_equal_to_the_maximum_answers
  	if answers.present? and answers.length > MAX_ANSWERS
	  errors.add(:answers, "too many") 
	end
  end

  def allowed_to_vote?(user)
	true
  end
end
