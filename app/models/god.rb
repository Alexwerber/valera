# frozen_string_literal: true

class God
  include Singleton

  class << self
    delegate :universes, :markets, :upstreams, to: :instance
  end

  def universes
    @universes ||= build_universes
  end

  def markets
    @markets ||= build_markets
  end

  def upstreams
    @upstreams ||= build_upstreams
  end

  def reset_settings!
    universes.each(&:reset_settings!)
  end

  private

  def build_upstreams
    Settings.upstreams.map do |key, config|
      Upstream.new key, config
    end
  end

  def build_markets
    Settings.markets.map do |name|
      Market.new(*name.split(':'))
    end
  end

  def build_universes
    universes = []
    Settings.universes.each_pair do |key, options|
      markets.map do |market|
        universe_class = options['class'].constantize
        settings = options.fetch('settings', {})
        settings = settings.fetch('global', {}).merge settings.dig('markets', market.id) || {}

        # TODO Use clients pool
        peatio_client = PeatioClient.new(
          **Rails.application.credentials.bots
          .fetch(options['credentials'].to_sym)
          .merge(name: key)
        )
        universes << universe_class.new(name: key, market: market, peatio_client: peatio_client,
                                        default_settings: settings, comment: options['comment'])
      end
    end
    universes
  end
end
