class ThatHook  < Redmine::Hook::ViewListener

    def view_layouts_base_html_head(context = {})
        stylesheet_link_tag('that', :plugin => 'that_email_log')
    end

    def view_layouts_base_content(context = {})
        if User.current.admin? && Setting.plugin_that_email_log['contextual_email_logs'] && context[:request].format == 'text/html'
            if context[:controller].controller_name == 'issues' && context[:controller].action_name == 'show'
                context[:controller].send(:render_to_string, :partial => 'email_logs/issues')
            elsif context[:controller].controller_name == 'messages' && context[:controller].action_name == 'show'
                context[:controller].send(:render_to_string, :partial => 'email_logs/messages')
            end
        end
    end

end
