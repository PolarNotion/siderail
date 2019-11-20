require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid if required fields are present' do
      user = build(:user)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end

    [ :first_name,
      :last_name,
      :email,
      :password,
    ].each do |x|

      it "is invalid if #{x} is not present" do
        user = build(:user, "#{x}" => nil)
        expect(user).not_to be_valid
        expect(user.errors).to have_key(x)
      end
    end
  end
end
