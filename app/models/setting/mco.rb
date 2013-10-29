class Setting::Mco < ::Setting
  BLANK_ATTRS << "use_mco"

  def self.load_defaults
    return unless ActiveRecord::Base.connection.table_exists?('settings')
    return unless super

    Setting.transaction do
      [
        self.set('use_mco', "Use MCO to execute remote commands", false),
      ].compact.each { |s| self.create s.update(:category => "Setting::Mco") }
    end
    true
  end
end