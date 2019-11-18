module EmailTrackerHelper

    def that_email_tracker(options = {})
        if Setting.plugin_that_email_log['email_tracking_image'] && controller.message && controller.message.message_id.present?
            image_tag(email_tracker_url(:message_id => controller.message.message_id), { :width => 1, :height => 1, :alt => nil }.merge(options))
        end
    end

end
