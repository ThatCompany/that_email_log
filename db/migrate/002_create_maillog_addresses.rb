class CreateMaillogAddresses < Rails::VERSION::MAJOR < 5 ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]

    def self.up
        create_table :maillog_addresses do |t|
            t.column :address,    :string,   :null => false, :limit => 191
            t.column :created_on, :datetime, :null => false
        end
        add_index :maillog_addresses, :address, :name => :maillog_addresses_address, :unique => true
    end

    def self.down
        drop_table :maillog_addresses
    end

end
