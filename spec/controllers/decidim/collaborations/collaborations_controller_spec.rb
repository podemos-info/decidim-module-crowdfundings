# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Collaborations
    describe CollaborationsController, type: :controller do
      routes { Decidim::Collaborations::Engine.routes }

      before do
        request.env["decidim.current_organization"] = feature.organization
        request.env["decidim.current_participatory_space"] = feature.participatory_space
        request.env["decidim.current_feature"] = feature
      end

      let(:feature) { create :collaboration_feature, :participatory_process }
      let(:params) do
        {
          feature_id: feature.id
        }
      end

      describe "index" do
        context "with one collaboration" do
          let!(:collaboration) { create(:collaboration, feature: feature) }
          let(:path) do
            EngineRouter
              .main_proxy(feature)
              .collaboration_path(collaboration)
          end

          it "redirects to the collaboration page" do
            get :index, params: params
            expect(response).to redirect_to(path)
          end
        end

        context "with several collaborations" do
          let!(:collaborations) { create_list(:collaboration, 2, feature: feature) }

          it "shows the index page" do
            get :index, params: params
            expect(response).to have_http_status(200)
          end
        end
      end
    end
  end
end
