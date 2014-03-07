module ForemanMco::HostsHelper
  extend ActiveSupport::Concern

  def mco_multiple_actions_select
    return unless User.current.allowed_to?(:execute_mco_commands)

    actions = []

    if Setting[:use_mco]
      actions <<  [_('Ping'), ping_commands_path, 'pencil']
      actions <<  [_('Install Package'),  install_package_commands_path, 'pencil', 'mco-filtered']
      actions <<  [_('Uninstall Package'),  uninstall_package_commands_path, 'pencil', 'mco-filtered']
      actions <<  [_('Service Status'),  service_status_commands_path, 'pencil', 'mco-filtered']
      actions <<  [_('Start Service'),  start_service_commands_path, 'pencil', 'mco-filtered']
      actions <<  [_('Stop Service'),  stop_service_commands_path, 'pencil', 'mco-filtered']
      actions <<  [_('Puppet Runonce'),  puppet_runonce_commands_path, 'pencil', 'mco-filtered']
      actions <<  [_('Puppet Enable'),  puppet_enable_commands_path, 'pencil', 'mco-filtered']
      actions <<  [_('Puppet Disable'),  puppet_disable_commands_path, 'pencil', 'mco-filtered']
    end

    select_action_button( _("Select MCO Action"), {:id => 'mco_submit_multiple'}, actions.map do |action|
      link_to(icon_text(action[2], action[0]) , action[1], :class=>'btn ' + (action.try(:[], 3) || ''),  :title => _("%s - The following hosts are about to be changed") % action[0])
    end.flatten)
  end
end
