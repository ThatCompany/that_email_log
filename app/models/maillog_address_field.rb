class MaillogAddressField < ActiveRecord::Base

    belongs_to :maillog
    belongs_to :address, :class_name => 'MaillogAddress'

    FIELD_FROM = 'From'
    FIELD_TO   = 'To'
    FIELD_CC   = 'CC'
    FIELD_BCC  = 'BCC'

end
