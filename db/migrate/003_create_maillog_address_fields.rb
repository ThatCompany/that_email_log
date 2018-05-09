class CreateMaillogAddressFields < ActiveRecord::Migration

    def self.up
        create_table :maillog_address_fields do |t|
            t.column :field,      :string,   :null => false
            t.column :maillog_id, :integer,  :null => false
            t.column :address_id, :integer,  :null => false
            t.column :created_on, :datetime, :null => false
        end
        add_index :maillog_address_fields, :maillog_id, :name => :maillog_address_fields_maillog_id
    end

    def self.down
        drop_table :maillog_address_fields
    end

end
