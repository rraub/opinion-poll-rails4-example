class Poll < ActiveRecord::Base
  has_many :answers
  has_many :votes, :through => :answers
  
  validate :has_minium_answers, :has_less_than_maximum_answers

  def has_minium_answers
  	errors.add(:answers, "not enough answers") if answers.length < 2
  end

  def has_less_than_maximum_answers
    errors.add(:answers, "too many answers") if answers.length > 5
  end
end
