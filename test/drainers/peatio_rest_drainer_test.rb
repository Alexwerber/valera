# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class PeatioRestDrainerTest < ActiveSupport::TestCase
  setup do
    account = Account.all.first
    @drainer = PeatioRestDrainer.new id: 1, market: Market.all.first, account: account
  end

  test 'fetch_market_depth' do
    assert_equal @drainer.send(:fetch_market_depth), { 'asksVolume' => 0.299e0, 'bidsVolume' => 0.3e0 }
    # { 'asksVolume' => 0.1300904919156e5, 'bidsVolume' => 0.111089629579e5 }
  end
end
