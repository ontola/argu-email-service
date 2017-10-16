class CreateTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :templates do |t|
      t.string :name
      t.boolean :show_footer
      t.timestamps
    end

    add_column :emails, :template_id, :integer

    [
      ['confirm_secondary', false],
      ['confirm_votes', false],
      ['confirmation', false],
      ['email_token_created', false],
      ['password_changed', true],
      ['requested_confirmation', false],
      ['set_password', false]
    ].each do |template, show_footer|
      EmailMessage
        .where('template = ?', template)
        .update_all(template_id: Template.create!(name: template, show_footer: show_footer).id)
    end

    change_column_null :emails, :template_id, false
    remove_column :emails, :template
    remove_column :emails, :mailer

    add_foreign_key :emails, :templates
    add_index :templates, :name, unique: true
  end
end
