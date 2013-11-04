Deface::Override.new(:virtual_path => "hosts/_list",
                     :name => "override_hosts_checkboxes",
                     :insert_before => 'table',
                     :text => '<%= javascript "foreman_mco/host_checkbox_modified" %>')
