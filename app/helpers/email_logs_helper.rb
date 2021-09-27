module EmailLogsHelper

    def render_email_addresses(addresses, with_emails = false)
        addresses.collect{ |address|
            address_key = address.downcase
            if @user_addresses_map[address_key]
                user_link = link_to_user(@user_addresses_map[address_key])
                with_emails ? content_tag('span', "#{user_link} &lt;#{address}&gt;".html_safe, :class => 'address') : user_link
            else
                content_tag('span', address, :class => 'address')
            end
        }.join(', ').html_safe
    end

    def render_subject(maillog)
        subject = h(maillog.subject)
        subject.sub!(/(?<=\A\[|\ARe: \[)#{Regexp.escape(h(maillog.project.name))}(?= -|\])/) do
            link_to_project(maillog.project)
        end if maillog.project
        notifiable = maillog.notifiable rescue nil
        notifiable = notifiable.issue if notifiable.is_a?(Journal)
        if notifiable.is_a?(Issue)
            subject.sub!(/(?<=- )#{Regexp.escape(h("#{notifiable.tracker} ##{notifiable.id}"))}(?=\])/) do
                link_to_issue(notifiable, :subject => false)
            end
        elsif notifiable.is_a?(Message)
            subject.sub!(/(?<=- )#{Regexp.escape(h(notifiable.board.name))} - msg#{notifiable.root.id}(?=\])/) do
                link_to(notifiable.board.name, project_board_path(notifiable.board.project, notifiable.board)) + ' - ' +
                link_to("msg#{notifiable.root.id}", board_message_path(notifiable.board_id, notifiable.parent_id || notifiable.id, {
                    :anchor => (notifiable.parent_id ? "message-#{notifiable.id}" : nil),
                    :r      => (notifiable.parent_id && notifiable.id)
                }))
            end
        end
        subject.html_safe
    end

    def render_maillog_links(maillogs)
        maillogs.sort.uniq(&:message_id).collect{ |maillog|
            message_id = maillog.opened? ? content_tag('span', maillog.message_id, :class => 'icon icon-checkmark') : maillog.message_id
            link_to(message_id, email_logs_path(:q => maillog.message_id), :class => 'email-log-link', :target => '_blank')
        }.join(',<br />').html_safe
    end

    def render_notifiable(maillog)
        method_name = "link_to_#{maillog.notifiable_type.underscore}".to_sym
        if respond_to?(method_name)
            send(method_name, maillog.notifiable)
        else
            "#{maillog.notifiable_type}##{maillog.notifiable_id}"
        end
    rescue
        content_tag('span', "#{maillog.notifiable_type}##{maillog.notifiable_id}", :class => 'notifiable-error')
    end

    def link_to_journal(journal, options = {})
        link_to("#{journal.issue.tracker} ##{journal.issue.id}", issue_path(journal.issue, :anchor => "change-#{journal.id}"),
                :class => journal.issue.css_classes) + ': ' + journal.issue.subject
    end

    def link_to_news(news)
        link_to(news.title, news_path(news))
    end

    def link_to_comment(comment)
        link_to(comment.commented.title, news_path(comment.commented, :anchor => 'comments'))
    end

    def link_to_wiki_content(wiki)
        link_to(wiki.page.pretty_title, url_for(:controller => 'wiki', :action => 'show', :project_id => wiki.project, :id => wiki.page.title))
    end

end
