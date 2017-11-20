# frozen_string_literal: true

require 'decidim/faker/localized'
require 'decidim/dev'

FactoryGirl.define do
  factory :collaboration_feature, parent: :feature do
    name { Decidim::Features::Namer.new(participatory_space.organization.available_locales, :collaborations).i18n_name }
    manifest_name :collaborations

    trait :participatory_process do
      participatory_space { create(:participatory_process, :with_steps, organization: organization) }
    end

    trait :assembly do
      participatory_space { create(:assembly, :published) }
    end
  end

  factory :collaboration, class: Decidim::Collaborations::Collaboration do
    title { Decidim::Faker::Localized.sentence(3) }
    description { Decidim::Faker::Localized.wrapped('<p>', '</p>') { Decidim::Faker::Localized.sentence(4) } }
    default_amount 50
    minimum_custom_amount 500
    target_amount 10_000
    total_collected 0
    amounts { Decidim::Collaborations.selectable_amounts }
    feature { create(:collaboration_feature, :participatory_process) }

    trait :assembly do
      feature { create(:collaboration_feature, :assembly) }
    end
  end

  factory :user_collaboration,
          class: Decidim::Collaborations::UserCollaboration do
    collaboration { create(:collaboration) }
    user { create(:user, organization: collaboration.feature.organization) }
    amount 50

    trait :punctual do
      frequency 'punctual'
    end

    trait :monthly do
      frequency 'monthly'
    end

    trait :quarterly do
      frequency 'quarterly'
    end

    trait :annual do
      frequency 'annual'
    end

    trait :pending do
      state 'pending'
    end

    trait :accepted do
      state 'accepted'
    end

    trait :rejected do
      state 'rejected'
    end
  end
end
