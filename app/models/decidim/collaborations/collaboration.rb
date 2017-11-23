# frozen_string_literal: true

module Decidim
  module Collaborations
    # Model for collaboration campaigns defined inside a
    # participatory space.
    class Collaboration < Decidim::Collaborations::ApplicationRecord
      include Decidim::Resourceable
      include Decidim::HasFeature
      include Decidim::Followable

      feature_manifest_name 'collaborations'

      has_many :user_collaborations,
               class_name: 'Decidim::Collaborations::UserCollaboration',
               foreign_key: 'decidim_collaborations_collaboration_id',
               dependent: :restrict_with_error

      scope :for_feature, ->(feature) { where(feature: feature) }

      # TODO Define whether this attribute will be stored or calculated
      # PUBLIC: Returns the amount collected by the campaign
      def total_collected
        user_collaborations.accepted.sum(:amount)
      end

      # PUBLIC Returns true if the collaboration campaign accepts donations.
      def accepts_donations?
        feature.participatory_space.published? &&
          (active_until.nil? || active_until >= Time.now) &&
          (target_amount > total_collected)
      end

      # PUBLIC returns the percentage of funds donated with regards to
      # the total collected
      def percentage
        result = (total_collected * 100.0) / target_amount
        result = 100.0 if result > 100
        result
      end

      # PUBLIC returns the percentage of funds donated by a user
      # with regards to the total collected.
      def user_percentage(user)
        result = (user_total_collected(user) * 100.0) / target_amount
        result = 100.0 if result > 100
        result
      end

      # PUBLIC returns the amount donated by a user
      def user_total_collected(user)
        user_collaborations.donated_by(user).accepted.sum(:amount)
      end

      # PUBLIC returns whether recurrent donations are allowed or not.
      def recurrent_donation_allowed?
        feature&.participatory_space_type == 'Decidim::Assembly'
      end
    end
  end
end
