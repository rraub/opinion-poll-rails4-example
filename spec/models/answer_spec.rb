require 'spec_helper'

describe Answer do
  # pending "add some examples to (or delete) #{__FILE__}"
  it "is invalid if it does not belong to a poll poll" do
  	answer = create(:answer, poll: nil)
  	answer.valid?.should be_false
  end

  it "is valid if it belongs to a poll" do
  	poll = create(:poll)
  	answer = create(:answer, poll: poll)
  	answer.valid?.should be_true
  end
end
