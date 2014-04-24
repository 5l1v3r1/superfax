class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :fax_id
      t.float :amount

      t.timestamps
    end
  end
end
