# frozen_string_literal: true

require 'decidim/faker/localized'
require 'decidim/dev'

FactoryGirl.define do
  factory :collaboration_feature, parent: :feature do
    name { Decidim::Features::Namer.new(participatory_space.organization.available_locales, :collaborations).i18n_name }
    manifest_name :collaborations
    participatory_space { create(:participatory_process, :with_steps, organization: organization) }
  end

  factory :collaboration, class: Decidim::Collaborations::Collaboration do
    title { Decidim::Faker::Localized.sentence(3) }
    description { Decidim::Faker::Localized.wrapped('<p>', '</p>') { Decidim::Faker::Localized.sentence(4) } }
    default_amount 50
    maximum_authorized_amount 500
    target_amount 10_000
    total_collected 5_534.33
    feature { create(:collaboration_feature) }
  end
end
