class EmailTrackerController < ApplicationController

    before_action :find_image_path

    skip_before_action :check_if_login_required, :check_password_change

    def index
        if params[:message_id].present? && (maillog = Maillog.find_by_message_id(params[:message_id]))
            maillog.open! unless maillog.opened?
        end
        send_file @image_path, :type => 'image/png', :disposition => 'inline'
    end

private

    def find_image_path
        return render_404 unless params[:image] =~ %r{\A[0-9a-z_\-]+\z}i
        @image_path = File.join(Redmine::Plugin.find(:that_email_log).assets_directory, 'images', "#{params[:image]}.png")
        render_404 unless File.exists?(@image_path)
    end

end
