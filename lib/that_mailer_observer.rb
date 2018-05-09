module ThatMailerObserver

    def self.delivered_email(mail)
        log = Maillog.build_from_mail(mail)
        unless log.save
            Rails.logger.warn "Failed writing maillog: #{log.errors.full_messages.join(', ')}"
        end
    rescue Exception => e
        Rails.logger.warn "Failed writing maillog: #{e.message}"
    end

end
