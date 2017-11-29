class AddLastOrderRequestDateToDecidimCollaborationsUserCollaboration < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_collaborations_user_collaborations, :last_order_request_date, :date
  end
end
