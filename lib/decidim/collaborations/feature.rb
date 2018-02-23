# frozen_string_literal: true

require "decidim/features/namer"

Decidim.register_feature(:collaborations) do |feature|
  feature.engine = Decidim::Collaborations::Engine
  feature.admin_engine = Decidim::Collaborations::AdminEngine
  feature.icon = "decidim/collaborations/icon.svg"
  feature.stylesheet = "decidim/collaborations/collaborations"

  feature.on(:before_destroy) do |instance|
    raise StandardError, "Can't remove this feature" if Decidim::Collaboration.where(feature: instance).any?
  end

  feature.register_resource do |resource|
    resource.model_class_name = "Decidim::Collaborations::Collaboration"
    resource.template = "decidim/collaborations/collaborations/linked_collaborations"
  end

  # These actions permissions can be configured in the admin panel
  feature.actions = %w(support)

  # Default authorization workflow for all feature instances
  feature.on(:create) do |instance|
    instance.update!(
      permissions: {
        "support" => {
          "authorization_handler_name" => "census",
          "options" => {
            "minimum_age" => 18,
            "allowed_document_types" => %w(dni nie)
          }
        }
      }
    )
  end

  # Ensure any authorization follow general rules
  feature.on(:permission_update) do |instance|
    permissions = instance.permissions["support"]

    handler_name = permissions["authorization_handler_name"]
    raise "The handler for this action must be census" if handler_name != "census"

    options = permissions["options"]

    minimum_age = options["minimum_age"]
    raise "You need to define a minimum_age key" unless minimum_age
    raise "The minimum age must be at least 18" if minimum_age.to_i < 18

    allowed_document_types = options["allowed_document_types"]
    raise "You need to define an allowed_document_types key" unless allowed_document_types
    raise "Allowed documents need to include DNI and NIE" unless allowed_document_types.include?("dni") && allowed_document_types.include?("nie")
  end

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
      description: Decidim::Faker::Localized.wrapped("<p>", "</p>") do
        Decidim::Faker::Localized.paragraph(3)
      end,
      terms_and_conditions: Decidim::Faker::Localized.wrapped("<p>", "</p>") do
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
        state: "accepted",
        last_order_request_date: Time.zone.today.beginning_of_month
      )
    end
  end
end
