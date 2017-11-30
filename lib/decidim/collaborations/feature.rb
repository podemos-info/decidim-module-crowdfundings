# frozen_string_literal: true

require 'decidim/features/namer'

Decidim.register_feature(:collaborations) do |feature|
  feature.engine = Decidim::Collaborations::Engine
  feature.admin_engine = Decidim::Collaborations::AdminEngine
  feature.icon = 'decidim/collaborations/icon.svg'
  feature.stylesheet = 'decidim/collaborations/collaborations'

  feature.on(:before_destroy) do |instance|
    if Decidim::Collaboration.where(feature: instance).any?
      raise StandardError, "Can't remove this feature"
    end
  end

  feature.register_resource do |resource|
    resource.model_class_name = 'Decidim::Collaborations::Collaboration'

    # TODO: The view linked collaborations needs to be implemented
    resource.template = 'decidim/collaborations/collaborations/linked_collaborations'
  end

  # These actions permissions can be configured in the admin panel
  feature.actions = %w[]

  feature.settings(:global) do |_settings|
  end

  feature.settings(:step) do |settings|
    settings.attribute :collaborations_allowed, type: :boolean, default: true
  end

  feature.register_stat :some_stat do |_features, _start_at, _end_at|
    # Register some stat number to the application
  end

  feature.seeds do |participatory_space|
    feature_name = Decidim::Features::Namer.new(
      participatory_space.organization.available_locales,
      :collaborations
    )

    feature = Decidim::Feature.create!(
      name: feature_name.i18n_name,
      manifest_name: :collaborations,
      published_at: Time.current,
      participatory_space: participatory_space
    )

    collaboration = Decidim::Collaborations::Collaboration.create!(
      feature: feature,
      title: Decidim::Faker::Localized.sentence(2),
      description: Decidim::Faker::Localized.wrapped('<p>', '</p>') do
        Decidim::Faker::Localized.paragraph(3)
      end,
      terms_and_conditions: Decidim::Faker::Localized.wrapped('<p>', '</p>') do
        Decidim::Faker::Localized.paragraph(5)
      end,
      minimum_custom_amount: 1_000,
      target_amount: 100_000,
      default_amount: 100,
      amounts: Decidim::Collaborations.selectable_amounts
    )

    3.times do
      author = Decidim::User.where(organization: feature.organization).all.sample

      Decidim::Collaborations::UserCollaboration.create!(
        user: author,
        collaboration: collaboration,
        amount: 50,
        state: 'accepted',
        last_order_request_date: Date.today.beginning_of_month
      )
    end
  end
end
