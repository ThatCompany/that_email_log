# That Email Log Plugin

This plugin enables logging of all outgoing email messages, that are sent by Redmine.

After installing this plugin you will see email logs under the new menu item in **Administration**:

![Email logs page](index.png)

If **Contextual email logs** are enabled in the plugin's settings (they are by default), email logs can also be accessed via the contextual links in issues and messages:

![Issue page](issue.png)

If **Email open tracking** is enabled in the plugin's settings and `mailer.html.erb` is modified accordingly (see below),
the plugin adds a tiny transparent image to outgoing emails. This image lets track, if the email has been opened by the user
(if users allowed to load images in their email clients).

## Installation

- Move `that_email_log` directory to the `plugins` directory of Redmine
- Run `rake redmine:plugins:migrate RAILS_ENV=production`
- Restart Redmine

If you want to enable email open tracking using the 1x1 pixel invisible image,
you also need to do the following:

- Copy `mailer.html.erb` from Redmine's `app/views/layouts/` to the same
  directory in the plugin
- Add `<%= that_email_tracker %>` somewhere in this file, e.g., before `</body>`

## License

GNU General Public License (GPL) v2.0

## Used Icons

- https://www.iconfinder.com/icons/95877/check_email_ok_icon (Icojam)
- https://www.iconfinder.com/icons/18351/link_icon (Everaldo Coelho)
