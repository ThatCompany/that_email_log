class EmailTrackerController < ApplicationController

    before_action :find_image_path

    skip_before_action :check_if_login_required, :check_password_change

    def index
        if params[:message_id].present? && (maillogs = Maillog.where(:message_id => params[:message_id]).to_a).any?
            maillogs.reject(&:opened?).each(&:open!)
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
