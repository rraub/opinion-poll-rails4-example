require 'spec_helper'

describe Vote do
  it "should be valid only when it has an answer" do
	@poll = build(:poll)
  	@poll.answers = 3.times.map do
      FactoryGirl.build(:answer, poll: @poll) 
    end 
	@poll.save.should be_true
    build(:vote, answer: @poll.answers.first).valid?.should be_true
    build(:vote, answer: nil).valid?.should be_false
  end

end
