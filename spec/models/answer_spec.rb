require 'spec_helper'

describe Answer do

  # it "is invalid if it does not belong to a poll" do
  # 	answer = build(:answer)
  # 	answer.valid?.should be_false
  # end

  it "is valid if it belongs to a poll" do
  	poll = build(:poll)
  	answer = build(:answer, poll: poll)
  	answer.valid?.should be_true
  end
end
