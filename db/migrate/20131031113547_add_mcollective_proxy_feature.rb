class AddMcollectiveProxyFeature < ActiveRecord::Migration
  def up
    Feature.create(:name => "MCollective")
  end

  def down
  end
end
