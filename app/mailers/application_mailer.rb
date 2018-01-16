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
    if opts[:to].include?('@argu.co')
      opts[:delivery_method] = :mailjet_api
      opts[:delivery_method_options] = {'CustomID' => record.id.to_s}
    end
    roadie_mail(opts)
  end

  private

  def template_options
    opts = {to: recipient.email, template_name: template.name}
    opts.merge!(send("#{template.name}_opts")) if respond_to?("#{template.name}_opts")
    options_with_subject(opts)
  end

  def options_with_subject(opts)
    opts[:subject] ||=
      t(opts[:subject_key] || "templates.#{template.name}.subject", opts[:subject_opts] || options).sub(/^./, &:upcase)
    opts.except(:subject_key, :subject_opts)
  end
end
