class Poll < ActiveRecord::Base
  has_many :answers
  has_many :votes, through: :answers

  accepts_nested_attributes_for :answers, reject_if: proc { |a| a[:name].blank? }, allow_destroy: true

  validate :has_minium_answers, :has_less_than_or_equal_to_the_maximum_answers, :updatable?
  validates :question, presence: true

  before_validation :ensure_question_punctuation

  MIN_ANSWERS = 2
  MAX_ANSWERS = 5

  #todo: unique answers
  
  def ensure_question_punctuation
    unless(self.question.blank?)
      self.question = self.question.strip
      unless(self.question.ends_with?('?'))
        self.question << "?"
      end
    end
    true
  end

  def build_placeholder_answers
    (Poll::MAX_ANSWERS - self.answers.to_a.count).times do
      self.answers.build
    end
  end

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
    !has_been_voted_on_by(user)  	
  end

  def updatable?
    Vote.joins(:answer).where('answers.poll_id' => self.id).count == 0
  end

  def updatable_by?(user)
    self.creator == user and self.updatable?
  end

  def has_been_voted_on_by(user)
    Vote.joins(:answer).where('answers.poll_id' => self.id, user: user).count != 0
  end
end
