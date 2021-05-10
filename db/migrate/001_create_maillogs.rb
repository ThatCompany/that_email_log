class CreateMaillogs < Rails::VERSION::MAJOR < 5 ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]

    def self.up
        create_table :maillogs do |t|
            t.column :message_id,      :string,   :null => false, :limit   => 191
            t.column :subject,         :string,   :null => false, :default => ''
            t.column :notifiable_type, :string,   :limit => 191
            t.column :notifiable_id,   :integer
            t.column :date,            :datetime, :null => false
            t.column :attachments,     :integer,  :null => false, :default => 0
            t.column :project_id,      :integer
            t.column :created_on,      :datetime, :null => false
        end
        add_index :maillogs, :message_id, :name => :maillogs_message_id, :unique => true
        add_index :maillogs, [ :notifiable_type, :notifiable_id ], :name => :maillogs_notifiable_type_id
    end

    def self.down
        drop_table :maillogs
    end

end
