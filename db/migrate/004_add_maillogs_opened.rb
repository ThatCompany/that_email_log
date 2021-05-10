class AddMaillogsOpened < Rails::VERSION::MAJOR < 5 ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]

    def self.up
    end

    def self.down
        if column_exists?(:maillogs, :opened, :boolean)
            remove_column :maillogs, :opened
        end
    end

end
