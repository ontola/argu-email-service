class AddApartment < ActiveRecord::Migration[5.2]
  def change
    create_table :email_identifiers do |t|
      t.integer :email_id, null: false
      t.string :tenant, null: false
      t.index %i[email_id tenant], unique: true
    end

    ApplicationRecord
      .connection
      .execute(
        'INSERT INTO email_identifiers (email_id, tenant) SELECT emails.id, \'argu\' FROM emails'
      )

    Apartment::Tenant.create('argu')

    excluded_tables = %w[ar_internal_metadata schema_migrations]
    public_tables = Apartment.excluded_models.map { |klass| klass.constantize.table_name.split('.').last }

    migrate_tables(ApplicationRecord.connection.tables - public_tables - excluded_tables)
  end

  def migrate_tables(tables)
    tables.each do |table|
      ApplicationRecord.connection.execute("INSERT INTO argu.#{table} SELECT * FROM public.#{table};")
      Apartment::Tenant.switch('argu') do
        ActiveRecord::Base.connection.reset_pk_sequence!(table)
      end
    end
  end
end
