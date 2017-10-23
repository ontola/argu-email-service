# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  include Roadie::Rails::Mailer
  include TemplateOptions

  default from: 'Argu <noreply@argu.co>',
          charset: 'UTF-8',
          content_type: 'text/html'
  layout 'mailer'
  add_template_helper(ActivityNotificationHelper)
  add_template_helper(MailerHelper)
  add_template_helper(UriTemplateHelper)

  attr_accessor :record
  delegate :recipient, :template, :options, to: :record

  def roadie_mail(_opts = {})
    m = super
    m.mailgun_variables = {'argu-mail-id' => record.id}
    m
  end

  def template_mail(record)
    self.record = record
    I18n.locale = record.recipient.language
    opts = template_options
    opts[:subject] = t(opts.delete(:subject_key), opts.delete(:subject_opts)).sub(/^./, &:upcase)
    roadie_mail(opts)
  end

  private

  def template_options
    opts = {
      to: recipient.email,
      subject_key: "templates.#{template.name}.subject",
      subject_opts: options,
      template_name: template.name
    }
    opts.merge!(send("#{template.name}_opts")) if respond_to?("#{template.name}_opts")
    opts
  end
end
