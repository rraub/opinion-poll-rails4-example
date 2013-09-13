# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :poll do
    question "my question"
    creator "1234"
    answers {
      Array(1..5).sample.times.map do
        FactoryGirl.create(:answer) 
      end
    }
  end
end
