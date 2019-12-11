require_dependency 'mailer'

module Patches
    module EmailTrackerMailerPatch

        def self.included(base)
            base.class_eval do
                unloadable

                default :message_id => lambda { |mailer|
                    return nil if mailer && mailer.instance_variable_get(:@message_id_object)
                    hash = [ 'redmine', Time.now.strftime('%Y%m%d%H%M%S'), Redmine::Utils.random_hex(8) ]
                    host = Setting.mail_from.to_s.strip.gsub(%r{^.*@|>}, '')
                    host = "#{::Socket.gethostname}.redmine" if host.empty?
                    "<#{hash.join('.')}@#{host}>"
                }

            end
        end

    end
end
