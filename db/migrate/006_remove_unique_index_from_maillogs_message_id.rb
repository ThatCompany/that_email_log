class RemoveUniqueIndexFromMaillogsMessageId < Rails::VERSION::MAJOR < 5 ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]

    def self.up
        remove_index :maillogs, :name => :maillogs_message_id
        add_index :maillogs, :message_id, :name => :maillogs_message_id
    end

    def self.down
        remove_index :maillogs, :name => :maillogs_message_id
        add_index :maillogs, :message_id, :name => :maillogs_message_id, :unique => true
    end

end
