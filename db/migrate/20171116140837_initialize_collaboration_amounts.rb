class InitializeCollaborationAmounts < ActiveRecord::Migration[5.1]
  def change
    Decidim::Collaborations::Collaboration.find_each do |collaboration|
      collaboration.amounts = Decidim::Collaborations.selectable_amounts
      collaboration.save
    end
  end
end
