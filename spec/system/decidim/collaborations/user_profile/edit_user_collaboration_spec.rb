# frozen_string_literal: true

require "spec_helper"

describe "Explore collaborations", type: :system do
  let(:collaboration) { create(:collaboration) }
  let(:organization) { collaboration.organization }
  let(:user) { create :user, :confirmed, organization: organization }

  let!(:user_collaboration) do
    create(:user_collaboration,
           :monthly,
           :accepted,
           user: user,
           collaboration: collaboration)
  end

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_collaborations_user_profile.user_collaborations_path
  end

  it "Link that edit the user collaboration exists" do
    expect(page).to have_link("", href: decidim_collaborations_user_profile.edit_user_collaboration_path(user_collaboration))
  end

  context "when edit link visited" do
    before do
      link = find_link("", href: decidim_collaborations_user_profile.edit_user_collaboration_path(user_collaboration))
      link.click
    end

    it "Navigates to update form" do
      expect(page).to have_content("SELECT THE AMOUNT")
      expect(page).to have_content("SELECT THE FREQUENCY")
      expect(page).to have_content("UPDATE")
    end
  end

  context "when updating user collaboration" do
    before do
      stub_totals_request(0)
      link = find_link("", href: decidim_collaborations_user_profile.edit_user_collaboration_path(user_collaboration))
      link.click

      find_button("Update").click
    end

    it "shows a success message" do
      expect(page).to have_content("Your collaboration has been successfully updated.")
    end
  end
end
