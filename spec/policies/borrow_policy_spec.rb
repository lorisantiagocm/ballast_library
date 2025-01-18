describe BorrowPolicy do
  subject { described_class }
  let!(:member) { create(:user) }
  let(:librarian) { create(:librarian) }
  let(:user_borrow) { create(:borrow, user: member) }
  let(:borrow) { create(:borrow) }

  permissions :update?, :create? do
    it "denies access if user is member" do
      expect(subject).not_to permit(member, Borrow.new)
    end

    it "grants access if user is librarian" do
      expect(subject).to permit(librarian, Borrow.new)
    end
  end
end
