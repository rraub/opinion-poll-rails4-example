# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :poll do
    question "my question"
    creator "1234"
    answers []
    
    factory :poll_with_answers do 
       after(:build) do |poll|
          Array(2..5).sample.times.map do
            poll.answers << build(:answer, poll: poll) 
          end
       end
    end
  end
end
