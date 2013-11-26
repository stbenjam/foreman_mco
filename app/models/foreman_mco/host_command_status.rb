module ForemanMco
  class HostCommandStatus < ActiveRecord::Base
    belongs_to :command_status

    default_scope lambda { order('foreman_mco_host_command_statuses.created_at') }

    scoped_search :on => :host, :complete_value => :true
    scoped_search :on => :status_code, :complete_value => :true
    scoped_search :on => :status_message, :complete_value => :true
    scoped_search :on => :created_at
  end
end
