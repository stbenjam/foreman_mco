module ForemanMco::HostsHelper
  extend ActiveSupport::Concern

  def mco_multiple_actions_select
    actions = []

    if Setting[:use_mco]
      actions <<  [_('Ping'), ping_commands_path, 'pencil', 'mco-action']
      actions <<  [_('Install Package'),  install_package_commands_path, 'pencil', 'mco-action']
      actions <<  [_('Uninstall Package'),  uninstall_package_commands_path, 'pencil', 'mco-action']
      actions <<  [_('Service Status'),  service_status_commands_path, 'pencil', 'mco-action']
      actions <<  [_('Start Service'),  start_service_commands_path, 'pencil', 'mco-action']
      actions <<  [_('Stop Service'),  stop_service_commands_path, 'pencil', 'mco-action']
    end

    content_tag :span, :id => 'mco_submit_multiple' do
      select_action_button( _("Select MCO Action"), actions.map do |action|
        link_to(icon_text(action[2], action[0]) , action[1], :class=>'btn ' + (action.try(:[], 3) || ''),  :title => _("%s - The following hosts are about to be changed") % action[0])
      end.flatten)
    end
  end
end