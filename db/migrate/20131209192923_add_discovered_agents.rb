class AddDiscoveredAgents < ActiveRecord::Migration
  def up
    create_table :foreman_mco_discovered_agents do |t|
      t.column :id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :type, :string, :null => false
    end

    create_table :foreman_mco_discovered_agent_fields do |t|
      t.column :id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :discovered_agents_id, :integer, :null => false
    end
  end

  def down
    drop_table :foreman_mco_discovered_agents
    drop_table :foreman_mco_discovered_agent_fields
  end
end
