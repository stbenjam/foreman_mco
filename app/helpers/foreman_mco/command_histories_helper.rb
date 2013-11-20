module ForemanMco::CommandHistoriesHelper
  def multiple_mco_actions_select
    actions = [
      [_('Ping'), ping_commands_path, 'pencil', 'mco-action'],
      [_('Pong'), ping_commands_path, 'pencil', 'mco-action']
    ]

    content_tag :span, :id => 'submit_multiple' do
      select_action_button( _("Select Action"), actions.map do |action|
        link_to(icon_text(action[2], action[0]) , action[1], :class=>'btn',  :title => _("'%s' is about to be executed.") % action[0])
      end.flatten)
    end
  end

end