class ForemanMco::CommandStatus < ActiveRecord::Base
  include ::Taxonomix

  PENDING = "pending"
  SUCCESS = "success"
  WARNING = "warning"
  FAILURE = "failure"
  
  TYPES = [PENDING, SUCCESS, WARNING, FAILURE,]

  before_validation :set_default_status

  validates :command, :jid, :presence => true
  validates :status, :inclusion => { :in => TYPES }

  def set_default_status
    self.status = PENDING if new_record?
  end
end