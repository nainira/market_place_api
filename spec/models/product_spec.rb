require 'rails_helper'

describe Product, :type => :model do
  let(:product) { FactoryGirl.build :product }
  subject { product }

  # it { should respond_to(:title) }
  # it { should respond_to(:price) }
  # it { should respond_to(:published) }
  # it { should respond_to(:user_id) }

  # it { should_not be_published }

  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:price) }
  it { is_expected.to respond_to(:published) }
  it { is_expected.to respond_to(:user_id) }

  it { is_expected.not_to be_published }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :price }
  it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_presence_of :user_id }
end
