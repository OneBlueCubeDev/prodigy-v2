$(document).ready(function() {
    $('.SingleChoiceCheckboxTable input[type=checkbox]').live('change', function() {
        var self = $(this);
        var parent = self.parent().parent().parent().parent();
        if (self.is(':checked')) {
            parent.find('input[type=checkbox]').prop('checked', false);
            self.prop('checked', true);
        }
    });
});