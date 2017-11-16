# frozen_string_literal: true

module Decidim
  module Collaborations
    class UserCollaboration < Decidim::Collaborations::ApplicationRecord
      belongs_to :collaboration,
                 class_name: 'Decidim::Collaborations::Collaboration',
                 foreign_key: 'decidim_collaborations_collaboration_id',
                 touch: true

      belongs_to :user,
                 class_name: 'Decidim::User',
                 foreign_key: 'decidim_user_id'

      enum state: %i[pending accepted rejected]

      validates :state, presence: true
      validates :amount, presence: true, numericality: {
        greater_than: 0
      }

      scope :donated_by, ->(user) { where(user: user) }
      scope :accepted, -> { where(state: 'accepted') }
    end
  end
end
