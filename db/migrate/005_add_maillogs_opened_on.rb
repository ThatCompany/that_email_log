class AddMaillogsOpenedOn < ActiveRecord::Migration

    def self.up
        add_column :maillogs, :opened_on, :datetime

        if column_exists?(:maillogs, :opened, :boolean)
            remove_column :maillogs, :opened
        end
    end

    def self.down
        remove_column :maillogs, :opened_on
    end

end
