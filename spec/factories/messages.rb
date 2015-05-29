FactoryGirl.define do
  factory :customer_message do
    subject 'Subject'
    body "Body.\nBody."
    customer
  end

  factory :staff_message do
    subject 'Subject'
    body "Body.\nBody."
    parent { FactoryGrirl.create(:customer_message) }
    staff_member
  end
end
