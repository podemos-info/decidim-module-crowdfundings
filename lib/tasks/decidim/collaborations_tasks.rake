# frozen_string_literal: true

namespace :decidim_collaborations do
  desc 'Executes recurrent payment orders'
  task recurrent_collaborations: :environment do
    Decidim::Collaborations::RenewUserCollaborations.run
  end
end

