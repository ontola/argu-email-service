# frozen_string_literal: true

class EmailMessage < ApplicationRecord
  self.table_name = 'emails'

  has_many :email_tracking_events, foreign_key: :email_id, dependent: :destroy, inverse_of: :email_message
  belongs_to :event
  belongs_to :template
  validates :recipient, presence: true
  after_create :create_email_indentifier

  def deliver_now
    touch # make sure the lock is still valid before sending the mail
    r = ApplicationMailer.template_mail(self).deliver_now
    update!(sent_at: Time.current, sent_to: r.to.first, mailgun_id: r.try(:message_id))
  end

  def email_status
    return NS.argu[:emailPending] if email_message.sent_at.nil?
    return NS.argu[:emailSent] if tracked_status.nil?

    NS.argu["email#{tracked_status}"]
  end

  def group
    @group ||= Group.find(options.fetch(:group_id))
  end

  def options
    super&.with_indifferent_access || {}
  end

  def profile
    @profile ||= ActiveResourceModel.find(:one, from: options.fetch(:actor_iri))
  end

  def recipient
    @recipient ||= User.new(attributes['recipient']) if attributes['recipient'].present?
  end

  private

  def create_email_indentifier
    EmailIdentifier.create!(email_id: id, tenant: Apartment::Tenant.current)
  end

  def email_message
    @email_message ||= EmailMessage.find_by(source_identifier: source_identifier)
  end

  def tracked_status
    @tracked_status ||= %i[clicked opened delivered dropped bounced].detect do |match|
      tracked_events.include?(match)
    end
  end

  def tracked_events
    @tracked_events ||= email_tracking_events.pluck(:event)
  end

  class << self
    def requested_single_resource(params, _user_context)
      find_by(source_identifier: params[:id])
    end
  end
end
