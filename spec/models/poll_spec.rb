require 'spec_helper'

describe Poll do
  
  it "is invalid when it has fewer than two answers" do
    poll = build(:poll) 
    poll.valid?.should be_false

    poll.answers = [ build(:answer, poll: poll) ]
    poll.valid?.should be_false

    poll.answers = 2.times.map do build(:answer, poll: poll) end 
    poll.valid?.should be_true
  end

  it "is valid only when it has five or fewer answers" do
    poll = build(:poll)
    poll.answers = 5.times.map do build(:answer, poll: poll) end 
    poll.valid?.should be_true
    
    poll.answers = 6.times.map do build(:answer, poll: poll) end
    poll.valid?.should be_false
  end

  it "only allows one vote per user" do
    poll = build(:poll)
    poll.answers = 5.times.map do build(:answer, poll: poll) end 
    poll.save.should be_true

    vote_one = build(:vote, user: 'bob', answer: poll.answers.first)
    vote_one.save.should be_true

    vote_two = build(:vote, user: 'bob', answer: poll.answers.last)
    vote_two.valid?.should be_false
  end


  it "is only updatable if it has no votes" do
    poll = build(:poll)
    poll.answers = 5.times.map do build(:answer, poll: poll) end 
    poll.save.should be_true
    poll.updatable?.should be_true
    create(:vote, answer: poll.answers.first)
    poll.updatable?.should be_false

  end
end
