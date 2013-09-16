require 'spec_helper'

describe Poll do
  describe "validation" do 
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
      poll = build(:poll_with_answers)
      poll.save.should be_true

      vote_one = build(:vote, user: 'bob', answer: poll.answers.first)
      vote_one.save.should be_true

      vote_two = build(:vote, user: 'bob', answer: poll.answers.last)
      vote_two.valid?.should be_false
    end

    it "is invalid without a question" do
      poll = build(:poll_with_answers)
      poll.question = ""
      poll.valid?.should be_false
    end
  end

  it "is only updatable if it has no votes" do
    poll = build(:poll)
    poll.answers = 5.times.map do build(:answer, poll: poll) end 
    poll.save.should be_true
    poll.updatable?.should be_true
    create(:vote, answer: poll.answers.first)
    poll.updatable?.should be_false
  end

  it "can tell if you've voted before" do
    poll = build(:poll_with_answers)
    poll.save!
    poll.has_been_voted_on_by('test').should be_false
    vote = create(:vote, answer_id: poll.answers.first.id, :user => 'test' )
    poll.has_been_voted_on_by('test').should be_true
  end

  describe "ensures a question mark at the end of your question" do
    it "adds one if it needs to" do
      poll = build(:poll_with_answers, question: 'no question mark')
      poll.save!
      poll.question.should eq('no question mark?')
    end

    it "doesn't add a question mark if there is one" do
      poll = build(:poll_with_answers, question: 'no question mark?')
      poll.save!
      poll.question.should eq('no question mark?')
    end
  end
end
