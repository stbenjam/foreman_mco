class CreateHostCommandStatuses < ActiveRecord::Migration
  def up
    create_table :foreman_mco_host_command_statuses do |t|
      t.references :command_status, :null => false
      t.column :host, :string, :null => false
      t.column :agent, :string, :null => false
      t.column :action, :string, :null => false
      t.column :status_code, :string, :null => false
      t.column :status_message, :text, :null => false
      t.column :result, :text
      t.timestamps
    end
  end

  def down
  end
end
