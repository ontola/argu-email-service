class RemoveApartment < ActiveRecord::Migration[7.0]
  def change
    remove_column :email_identifiers, :tenant
    add_index :email_identifiers, :email_id

    excluded_tables = %w[ar_internal_metadata schema_migrations events]
    public_tables = %w[email_identifiers]
    prio_tables = %w[templates]

    migrate_tables(prio_tables)
    migrate_tables(ApplicationRecord.connection.tables - public_tables - excluded_tables - prio_tables)
  end

  private

  def migrate_tables(tables)
    tables.each do |table|
      ApplicationRecord.connection.execute("INSERT INTO public.#{table} SELECT * FROM argu.#{table};")
      ActiveRecord::Base.connection.reset_pk_sequence!(table)
    end
  end
end
