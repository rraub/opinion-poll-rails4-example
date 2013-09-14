require 'spec_helper'

describe Vote do
  before(:all) do 
	@poll = build(:poll)
  	@poll.answers = 3.times.map do
      FactoryGirl.build(:answer, poll: @poll) 
    end 
	@poll.save.should be_true
  end

  it "should be valid only when it has an answer" do
    build(:vote, answer: @poll.answers.first).valid?.should be_true
    build(:vote, answer: nil).valid?.should be_false
  end

  pending "should not allow more than vote from the same user" do
  	create(:vote, user: 'bob', answer: @poll.answers.first)

	second_vote = build(:vote, user: 'bob', answer: @poll.answers.first)
	second_vote.valid?.should be_false
  end

end
