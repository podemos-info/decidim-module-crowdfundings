class AddPaymentMethodIdToDecidimCollaborationsUserCollaboration < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_collaborations_user_collaborations, :payment_method_id, :integer
  end
end
