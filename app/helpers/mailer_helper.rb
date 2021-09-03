# frozen_string_literal: true

require 'redcarpet/render_strip'

module MailerHelper
  def organisation_color(attr)
    "#{attr}: #{ActsAsTenant.current_tenant.try(:primary_color) || '#2D7080'}"
  end

  def recipient
    @record.recipient
  end

  def opts
    @record.options
  end

  def show_footer?
    @record.template.show_footer?
  end

  def greet_recipient
    I18n.t('greeting', name: recipient.try(:display_name) || '')
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

  def revert_dynamic_iri(url)
    url.sub(Rails.application.config.frontend_url, Rails.application.config.origin)
  end

  def truncate(body)
    HTML_Truncator.truncate(body, 250, length_in_chars: true, ellipsis: ' ...')
  end
end
