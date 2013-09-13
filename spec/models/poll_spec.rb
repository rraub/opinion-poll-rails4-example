require 'spec_helper'

describe Poll do
  
  it "is valid only when it has two to five answers" do
  	poll = build(:poll)
  	poll.valid?.should be_false
  	answers = Array(1..5).sample.times.map do build(:answer, poll: poll) end
  	# poll = build(:poll, answers: answers )	
    poll.answers = answers 
    poll.valid?.should be_true
    
  end

end
