module ForemanMco::CommandHistoriesHelper
  def any_commands_run?
    return true unless (@command_statuses.count == 0)
    false
  end
end
