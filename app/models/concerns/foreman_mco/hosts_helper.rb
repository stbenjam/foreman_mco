module ForemanMco::HostsHelper
  extend ActiveSupport::Concern

  included do
    alias_method :multiple_actions_select, :multiple_actions_select_with_mco_commands
  end

  def multiple_actions_select_with_mco_commands
    actions = [
      [_('Change Group'), select_multiple_hostgroup_hosts_path, 'pencil'],
      [_('Change Environment'), select_multiple_environment_hosts_path, 'chevron-right'],
      [_('Edit Parameters'), multiple_parameters_hosts_path, 'edit'],
      [_('Delete Hosts'), multiple_destroy_hosts_path, 'trash'],
      [_('Disable Notifications'), multiple_disable_hosts_path, 'eye-close'],
      [_('Enable Notifications'), multiple_enable_hosts_path, 'bullhorn'],
    ]
    actions.insert(1, [_('Build Hosts'), multiple_build_hosts_path, 'fast-forward']) if SETTINGS[:unattended]
    actions <<  [_('Run Puppet'), multiple_puppetrun_hosts_path, 'play'] if Setting[:puppetrun]
    actions <<  [_('Assign Organization'), select_multiple_organization_hosts_path, 'tags'] if SETTINGS[:organizations_enabled]
    actions <<  [_('Assign Location'), select_multiple_location_hosts_path, 'map-marker'] if SETTINGS[:locations_enabled]
    if Setting[:use_mco]
      actions <<  [_('Install Package'),  install_package_commands_path, 'pencil', 'mco-action']
      actions <<  [_('Uninstall Package'),  uninstall_package_commands_path, 'pencil', 'mco-action']
      actions <<  [_('Service Status'),  service_status_commands_path, 'pencil', 'mco-action']
      actions <<  [_('Start Service'),  start_service_commands_path, 'pencil', 'mco-action']
      actions <<  [_('Stop Service'),  stop_service_commands_path, 'pencil', 'mco-action']
    end

    content_tag :span, :id => 'submit_multiple' do
      select_action_button( _("Select Action"), actions.map do |action|
        link_to(icon_text(action[2], action[0]) , action[1], :class=>'btn ' + (action.try(:[], 3) || ''),  :title => _("%s - The following hosts are about to be changed") % action[0])
      end.flatten)
    end
  end
end