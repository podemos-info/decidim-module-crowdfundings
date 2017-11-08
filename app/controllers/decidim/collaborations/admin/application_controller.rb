# frozen_string_literal: true

module Decidim
  module Collaborations
    module Admin
      # This controller is the abstract class from which all other controllers of
      # this engine inherit.
      #
      # Note that it inherits from `Decidim::Features::BaseController`, which
      # override its layout and provide all kinds of useful methods.
      class ApplicationController < Decidim::Admin::Features::BaseController
        helper_method :collaborations, :collaboration

        def collaborations
          @collaborations ||= Collaboration
                              .for_feature(current_feature)
                              .page(params[:page])
                              .per(15)
        end

        def collaboration
          @collaborations ||= collaborations.find(params[:id])
        end
      end
    end
  end
end
