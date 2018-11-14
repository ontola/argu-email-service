# frozen_string_literal: true

require 'redcarpet/render_strip'

module MailerHelper
  def recipient
    @record.recipient
  end

  def opts
    @record.options
  end

  def show_footer?
    @record.template.show_footer?
  end

  def greeting_row
    return if recipient.try(:display_name).blank?
    content_tag(:tr) do
      content_tag(:td, class: 'mail-p') do
        I18n.t('greeting', name: recipient.display_name)
      end
    end
  end

  def markdown_to_html(markdown)
    return if markdown.blank?
    @html_renderer ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(escape_html: true))
    @html_renderer.render(markdown)
  end

  def markdown_to_plaintext(markdown)
    return if markdown.blank?
    @plaintext_renderer ||= Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
    @plaintext_renderer.render(markdown)
  end

  def truncate(body)
    HTML_Truncator.truncate(body, 250, length_in_chars: true, ellipsis: ' ...')
  end
end
