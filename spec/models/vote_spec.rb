require 'spec_helper'

describe Vote do
  it "should be valid only when it has an answer" do
  	answer = build(:answer)
    build(:vote, answer: answer).valid?.should be_true
    build(:vote, answer: nil).valid?.should be_false
  end


end
