module Decidim::Collaborations
  class Collaboration < ApplicationRecord
    include Decidim::Resourceable
    include Decidim::HasFeature
    include Decidim::Followable

    feature_manifest_name 'collaborations'

    scope :for_feature, ->(feature) { where(feature: feature) }
  end
end
