# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    name "MyString"
    poll nil
    votes []

    factory :answer_with_votes do
      votes {
         Array(1..10).sample.times.map do
          FactoryGirl.create(:vote) 
        end
      }
  end
  end
end
