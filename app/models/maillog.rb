class Maillog < ActiveRecord::Base
    belongs_to :project
    belongs_to :notifiable, :polymorphic => true

    has_many :address_fields, :class_name => 'MaillogAddressField', :dependent => :destroy

    validate :validate_recipients

    before_create :set_default_date
    after_save :save_address_fields

    scope :like, lambda { |q|
        unless q.blank?
            pattern = "%#{q.strip.downcase}%"
            joins(:address_fields => :address).
            where("LOWER(#{table_name}.subject) LIKE :q OR LOWER(#{table_name}.message_id) LIKE :q OR LOWER(#{MaillogAddress.table_name}.address) LIKE :q", :q => pattern).
            uniq
        else
            where(nil)
        end
    }

    def self.build_from_mail(mail)
        maillog = new(:message_id => mail.message_id, :subject => mail.subject, :date => mail.date)
        maillog.from = mail.from if mail.from
        maillog.to   = mail.to   if mail.to
        maillog.cc   = mail.cc   if mail.cc
        maillog.bcc  = mail.bcc  if mail.bcc
        maillog.attachments = mail.attachments.size if mail.has_attachments?
        headers = [ mail.message_id, mail.references ].flatten.compact
        if headers.detect{ |header| header.to_s =~ MailHandler::MESSAGE_ID_RE }
            maillog.notifiable_type = $1.camelize
            maillog.notifiable_id = $2.to_i
        end
        if header = mail.header['X-Redmine-Project']
            maillog.project = Project.find_by_identifier(header.value)
        end
        maillog
    end

    def from=(addresses); set_address_fields(MaillogAddressField::FIELD_FROM, addresses); end
    def to=(addresses);   set_address_fields(MaillogAddressField::FIELD_TO,   addresses); end
    def cc=(addresses);   set_address_fields(MaillogAddressField::FIELD_CC,   addresses); end
    def bcc=(addresses);  set_address_fields(MaillogAddressField::FIELD_BCC,  addresses); end

    def addresses
        address_fields.collect{ |field| field.address.address }
    end

    def recipients
        address_fields.select{ |address| address.field != MaillogAddressField::FIELD_FROM }
                      .collect{ |field| field.address.address }
    end

    def addresses_by_fields
        address_fields.group_by(&:field).inject({}) do |hash, (field, addresses)|
            hash[field] = addresses.collect{ |item| item.address.address }
            hash
        end
    end

    def open!
        update_attribute(:opened, true)
    end

private

    def set_default_date
        self.date ||= Time.now
    end

    def set_address_fields(field, emails)
        @address_fields ||= []
        @address_fields += emails.collect do |email|
            begin
                MaillogAddress.find_or_create_by(:address => email)
            rescue ActiveRecord::RecordNotUnique
                retry
            end
        end.collect do |address|
            MaillogAddressField.new(:field => field, :address => address)
        end
    end

    def validate_recipients
        if @address_fields.select{ |address| address.field != MaillogAddressField::FIELD_FROM }.empty?
            errors.add(:base, l(:label_field_to) + ' ' + l('activerecord.errors.messages.blank'))
        end
    end

    def save_address_fields
        @address_fields.each do |field|
            field.maillog = self
            field.save
        end if @address_fields
    end

end
