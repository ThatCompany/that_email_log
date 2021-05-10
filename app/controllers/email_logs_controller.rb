class EmailLogsController < ApplicationController
    layout 'admin'
    self.main_menu = false if self.respond_to?(:main_menu)

    before_action :require_admin
    before_action :find_notifiable, :only => :show

    def index
        scope = Maillog.all
        if params[:from].present?
            begin; @from = params[:from].to_date; rescue; end
            scope = scope.where("#{Maillog.table_name}.date > ?", @from) if @from
        end
        if params[:to].present?
            begin; @to = params[:to].to_date + 1; rescue; end
            scope = scope.where("#{Maillog.table_name}.date < ?", @to) if @to
        end
        scope = scope.like(params[:q]) if params[:q].present?
        @maillog_count = scope.count
        @maillog_pages = Paginator.new(@maillog_count, per_page_option, params[:page])
        @maillogs = scope.preload(:address_fields => :address).order(:id => :desc).limit(@maillog_pages.per_page).offset(@maillog_pages.offset).to_a
        @user_addresses_map = load_addresses_map
    end

    def show
        addresses = @maillogs.collect{ |maillog| maillog.recipients }.flatten.uniq
        @recipients = User.active.having_mail(addresses).to_a
        if request.xhr?
            render :layout => false
        else
            redirect_to email_logs_path(:q => "redmine.#{@notifiable.class.name.demodulize.underscore}-#{@notifiable.id}.")
        end
    end

private

    def load_addresses_map
        addresses = @maillogs.collect{ |maillog| maillog.addresses }.flatten.uniq
        map = EmailAddress.select(:user_id, :address)
                          .where("LOWER(address) IN (?)", addresses.map{ |address| address.downcase })
                          .inject({}) do |hash, record|
            hash[record.address.downcase] = record.user_id
            hash
        end
        users = User.active.where(:id => map.values.uniq).inject({}) do |hash, user|
            hash[user.id] = user
            hash
        end
        map.transform_values{ |user_id| users[user_id] }.compact
    end

    def find_notifiable
        klass       = Object.const_get(params[:object_type].camelcase)
        @notifiable = klass.find(params[:object_id])
        @maillogs   = Maillog.where(:notifiable => @notifiable).to_a
        render_404 unless @maillogs.any?
    rescue NameError, ActiveRecord::RecordNotFound
        render_404
    end

end
