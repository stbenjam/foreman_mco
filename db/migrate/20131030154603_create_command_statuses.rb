class CreateCommandStatuses < ActiveRecord::Migration
  def up
    create_table :foreman_mco_command_statuses do |t|
      t.column :jid, :string, :null => false
      t.column :execution_plan_id, :string, :null => false
      t.column :command, :text, :null => false
      t.column :status, :string, :null => false
      t.timestamps
    end
  end

  def down
    drop_table :foreman_mco_command_statuses
  end
end
