require 'redmine'

Rails.configuration.to_prepare do
  require_dependency 'that_hook'
end

Rails.logger.info 'Starting That Email Log plugin for Redmine'

Rails.configuration.to_prepare do
    unless Mailer.included_modules.include?(Patches::EmailTrackerMailerPatch)
        Mailer.send(:include, Patches::EmailTrackerMailerPatch)
    end

    unless Mailer.included_modules.include?(EmailTrackerHelper)
        Mailer.send(:helper, :email_tracker)
        Mailer.send(:include, EmailTrackerHelper)
    end

    if Redmine::Plugin.installed?(:redmine_mentions)
        unless MentionMailer.included_modules.include?(EmailTrackerHelper)
            MentionMailer.send(:helper, :email_tracker)
            MentionMailer.send(:include, EmailTrackerHelper)
        end
    end
end

Redmine::Plugin.register :that_email_log do
    name 'That Email Log'
    author 'Andriy Lesyuk for That Company'
    author_url 'http://www.andriylesyuk.com/'
    description 'Enables logging of all outgoing email messages that are sent by Redmine.'
    url 'https://github.com/thatcompany/that_email_log'
    version '0.0.4'

    menu :admin_menu, :email_logs, :email_logs_path, :html => { :class => 'icon icon-email-logs' }, :before => :info

    settings :default => {
        'contextual_email_logs' => true,
        'email_tracking_image'  => false
    }, :partial => 'settings/email_log'
end

ActionMailer::Base.register_observer(ThatMailerObserver)
