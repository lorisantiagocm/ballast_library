require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  let(:member) { build(:user) }
  let(:librarian) { build(:librarian) }
  let(:invalid_user) { build(:user, email: nil) }

  it 'should be valid' do
    expect(user).to be_valid
  end

  it 'has role "member" by default' do
    expect(User.new.role).to eq('member')
  end

  it 'can have the following roles: "member" and "librarian"' do
    expect(member.role).to eq('member')
    expect(librarian.role).to eq('librarian')

    expect(member).to be_valid
    expect(librarian).to be_valid
  end

  it 'requires email' do
    expect(invalid_user).to be_invalid
  end
end
