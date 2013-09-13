# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    name "MyString"
    poll nil
    votes {
       Array(1..5).sample.times.map do
        FactoryGirl.create(:vote) 
      end
    }
  end
end
