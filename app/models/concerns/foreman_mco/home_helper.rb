module ForemanMco::HomeHelper
  extend ActiveSupport::Concern

  included do
    alias_method_chain :settings_menu_items, :mco_history
  end

  def settings_menu_items_with_mco_history
    menu_items = settings_menu_items_without_mco_history
    menu_items.insert(-3, [_('MCollective History'), "foreman_mco/command_histories"])
    menu_items.insert(-3, [:divider])
  end
end