# frozen_string_literal: true

module MailerHelper
  def recipient
    @record.recipient
  end

  def opts
    @record.options
  end

  def show_footer?
    @record.mailer.constantize.show_footer?
  end

  def greeting_row
    return if recipient.try(:display_name).blank?
    content_tag(:tr) do
      content_tag(:td, class: 'mail-p') do
        I18n.t('greeting', name: recipient.display_name)
      end
    end
  end
end
