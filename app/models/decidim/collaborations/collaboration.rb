module Decidim::Collaborations
  class Collaboration < ApplicationRecord
    include Decidim::Resourceable
    include Decidim::HasFeature
    include Decidim::Followable

    feature_manifest_name 'collaborations'

    has_many :user_collaborations,
             class_name: 'Decidim::Collaborations::UserCollaboration',
             foreign_key: 'decidim_collaborations_collaboration_id',
             dependent: :restrict_with_error

    scope :for_feature, ->(feature) { where(feature: feature) }

    # PUBLIC Returns true if the collaboration campaign accepts donations.
    def accepts_donations?
      feature.participatory_space.published? &&
        (active_until.nil? || active_until >= DateTime.now) &&
        (target_amount > total_collected)
    end
  end
end
