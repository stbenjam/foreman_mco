Deface::Override.new(:virtual_path => "hosts/index",
  :name => "add_mco_hosts_actions",
  :replace => "erb[silent]:contains('title_actions')",
  :text => '<% title_actions mco_multiple_actions_select, multiple_actions_select, (link_to_if_authorized _("New Host"), hash_for_new_host_path) %>')

Deface::Override.new(:virtual_path => "hosts/_list",
  :name => "support_mco_hosts_checkboxes",
  :insert_before => 'table',
  :text => '<%= javascript "foreman_mco/mco_hosts_extensions" %>')