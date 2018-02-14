# frozen_string_literal: true

shared_context "with assembly feature" do
  let(:manifest) { Decidim.find_feature_manifest(manifest_name) }

  let(:user) { create :user, :confirmed, organization: organization }
  let!(:organization) { create(:organization) }

  let(:assembly) do
    create(:assembly, organization: organization)
  end

  let(:participatory_space) { assembly }

  let!(:feature) do
    create(:feature,
           manifest: manifest,
           participatory_space: assembly)
  end

  before do
    switch_to_host(organization.host)
  end

  def visit_feature
    page.visit main_feature_path(feature)
  end
end
