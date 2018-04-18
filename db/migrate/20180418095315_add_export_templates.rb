class AddExportTemplates < ActiveRecord::Migration[5.0]
  def up
    Template.create!(name: 'export_failed')
    Template.create!(name: 'export_done')
  end

  def down
    Template.find_by(name: 'export_failed').destroy
    Template.find_by(name: 'export_done').destroy
  end
end
