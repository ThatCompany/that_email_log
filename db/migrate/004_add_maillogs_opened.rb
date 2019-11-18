class AddMaillogsOpened < ActiveRecord::Migration

    def self.up
        add_column :maillogs, :opened, :boolean, :default => false, :null => false
    end

    def self.down
        remove_column :maillogs, :opened
    end

end
