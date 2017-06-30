# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  include Roadie::Rails::Mailer

  default from: 'Argu <noreply@argu.co>',
          charset: 'UTF-8',
          content_type: 'text/html'
  layout 'mailer'
  add_template_helper(MailerHelper)
  add_template_helper(UriTemplateHelper)

  def initialize(record)
    @record = record
    I18n.locale = record.recipient.language
    super()
  end
  attr_accessor :record
  delegate :recipient, to: :record

  def roadie_mail(_opts = {})
    m = super
    m.mailgun_variables = {'argu-mail-id' => record.id}
    m
  end

  def self.show_footer?
    true
  end

  def self.method_missing(method_name, *args) # :nodoc:
    if action_methods.include?(method_name.to_s)
      Argu::MessageDelivery.new(self, method_name, *args)
    else
      super
    end
  end
end
