class AddMailerToEmails < ActiveRecord::Migration[5.0]
  def change
    add_column :emails, :mailer, :string
    EmailMessage.find_each do |email|
      email.update!(mailer: "#{email.event.resource_type.classify}Mailer")
    end
    change_column_null :emails, :mailer, false
  end
end
