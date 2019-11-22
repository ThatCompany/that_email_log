class AddMaillogsOpened < ActiveRecord::Migration

    def self.up
    end

    def self.down
        if column_exists?(:maillogs, :opened, :boolean)
            remove_column :maillogs, :opened
        end
    end

end
