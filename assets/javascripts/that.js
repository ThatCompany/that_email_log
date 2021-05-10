function addJournalEmailLogLink(label, path, options) {
    var $this = $(this);
    var journalId = $this.attr('id').substring(7);
    var $contextual, $target;
    var $details = $this.find('ul.details');
    var $journalActions;
    if (options.a_common_libs) {
        $contextual = $this.find('.contextual');
        if ($details.length > 0) {
            if ($contextual.length == 0) {
                $contextual = $target = $('<div>', { 'class': 'contextual' });
                $contextual.appendTo($this.find('h4'));
            }
            $target = $details;
        } else {
            $target = $this.find('div.wiki').first();
        }
    } else {
        if ($details.length > 0) {
            $contextual = $this.children('div').children('.contextual');
            if ($contextual.length > 0) {
                $target = $details;
            } else {
                $contextual = $target = $('<div>', { 'class': 'contextual' });
                $details.before($contextual);
            }
        } else {
            $contextual = $this.find('.contextual');
            $target = $this.find('div.wiki').first();
        }
    }
    $journalActions = $contextual.children('.journal-actions');
    if ($journalActions.length > 0) {
        $contextual = $journalActions;
    }
    if ($contextual.length > 0) {
        $('<a>', {
            title: label,
            'class': 'icon-only icon-email-log',
            href: path + '?q=redmine.journal-' + journalId + '.',
            text: label,
            click: function() {
                var $emailLog = $this.find('div.email-log');
                if ($emailLog.length > 0) {
                    $emailLog.toggle();
                } else {
                    $.ajax({
                        url: path + '/journal/' + journalId,
                        success: function(data) {
                            $target.before(data);
                        }
                    });
                }
                return false;
            }
        }).appendTo($contextual.first()).before(' ');
    }
}
