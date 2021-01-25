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

  def template_mail(record)
    self.record = record
    I18n.locale = record.recipient.language
    opts = template_options
    opts[:delivery_method_options] = {'CustomID' => record.id.to_s}
    roadie_mail(opts)
  end

  private

  def template_options
    opts = {
      from: ActsAsTenant.current_tenant.from,
      template_name: template.name,
      to: recipient.email
    }
    opts.merge!(send("#{template.name}_opts")) if respond_to?("#{template.name}_opts")
    options_with_subject(opts)
  end

  def options_with_subject(opts)
    opts[:subject] ||=
      I18n.t(
        opts[:subject_key] || "templates.#{template.name}.subject",
        **(opts[:subject_opts] || options)
      ).sub(/^./, &:upcase)
    opts.except(:subject_key, :subject_opts)
  end
end
