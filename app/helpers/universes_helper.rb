# frozen_string_literal: true

module UniversesHelper
  def universe_settings_attribute_input(universe, attribute)
    side = attribute.to_s.split('_').first
    currency_method = side == 'bid' ? :quote : :base
    display_with = ->(value) { format_percent value } if attribute.to_s.include? '_threshold'
    if attribute.to_s.include? '_volume'
      display_with = lambda { |value|
        format_money value, universe.market.send(currency_method)
      }
    end
    type = attribute.to_s.include?('enabled') ? :checkbox : :input
    best_in_place universe.settings, attribute, as: type, display_with: display_with
  end

  STATUS_LABELS = {
    init: 'badge-info',
    active: 'badge-success',
    inactive: 'badge-warning'
  }

  def universe_status(universe)
    content_tag :span, class: 'badge ' + STATUS_LABELS[universe.settings.status] do
      universe.settings.status.to_s
    end
  end
end
