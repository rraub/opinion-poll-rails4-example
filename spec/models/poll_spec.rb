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

end
