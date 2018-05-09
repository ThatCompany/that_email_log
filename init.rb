require 'redmine'

require_dependency 'that_hook'

Rails.logger.info 'Starting That Email Log plugin for Redmine'

Redmine::Plugin.register :that_email_log do
    name 'That Email Log'
    author 'Andriy Lesyuk'
    author_url 'http://www.andriylesyuk.com/'
    description 'Enables logging of all outgoing email messages that are sent by Redmine.'
    url 'https://github.com/thatcompany/that_email_log'
    version '0.0.1'

    menu :admin_menu, :email_logs, :email_logs_path, :html => { :class => 'icon icon-email-logs' }, :before => :info

    settings :default => { 'contextual_email_logs' => true }, :partial => 'settings/email_log'
end

ActionMailer::Base.register_observer(ThatMailerObserver)
