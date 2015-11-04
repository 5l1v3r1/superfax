class AddStatusToFaxes < ActiveRecord::Migration
  def change
    add_column :faxes, :status, :integer
  end
end
