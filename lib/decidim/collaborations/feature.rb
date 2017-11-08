# frozen_string_literal: true

require 'decidim/features/namer'

Decidim.register_feature(:collaborations) do |feature|
  feature.engine = Decidim::Collaborations::Engine
  feature.admin_engine = Decidim::Collaborations::AdminEngine
  feature.icon = 'decidim/collaborations/icon.svg'
  feature.stylesheet = 'decidim/collaborations/collaborations'

  feature.on(:before_destroy) do |instance|
    raise StandardError, "Can't remove this feature" if Decidim::Collaboration.where(feature: instance).any?
  end

  feature.register_resource do |resource|
    resource.model_class_name = 'Decidim::Collaborations::Collaboration'
    resource.template = 'decidim/collaborations/collaborations/linked_collaborations'
  end


  # These actions permissions can be configured in the admin panel
  feature.actions = %w[]

  feature.settings(:global) do |settings|
  end

  feature.settings(:step) do |settings|
    settings.attribute :collaborations_allowed, type: :boolean, default: true
  end

  # # Register an optional resource that can be referenced from other resources.
  # feature.register_resource do |resource|
  #   resource.model_class_name = "Decidim::Collaborations::<ResourceName>"
  #   resource.template = "decidim/collaborations/<resource_view_folder>/linked_<resource_name_plural>"
  # end

  feature.register_stat :some_stat do |features, start_at, end_at|
    # Register some stat number to the application
  end

  feature.seeds do |participatory_space|
    feature = Decidim::Feature.create!(
      name: Decidim::Features::Namer.new(participatory_space.organization.available_locales, :collaborations).i18n_name,
      manifest_name: :collaborations,
      published_at: Time.current,
      participatory_space: participatory_space
    )

  end
end
