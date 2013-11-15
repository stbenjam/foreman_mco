class ForemanMco::CommandStatus < ActiveRecord::Base
  include ::Taxonomix

  PENDING = "pending"
  SUCCESS = "success"
  WARNING = "warning"
  FAILURE = "failure"
  
  TYPES = [PENDING, SUCCESS, WARNING, FAILURE]

  before_validation :set_default_status

  validates :command, :jid, :presence => true
  validates :status, :inclusion => { :in => TYPES }

  default_scope lambda { order('foreman_mco_command_statuses.updated_at') }

  scoped_search :on => :command, :complete_value => :true
  scoped_search :on => :status, :complete_value => :true
  scoped_search :on => :updated_at
  scoped_search :on => :created_at

  def set_default_status
    self.status = PENDING if new_record?
  end
end