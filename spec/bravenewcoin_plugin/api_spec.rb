require 'spec_helper'

describe Killbill::BraveNewCoinPlugin::DefaultPlugin do

  before(:each) do
    Killbill::BraveNewCoinPlugin::Ticker.delete_all
  end

  it 'should test plugin apis with no data' do
    api = Killbill::BraveNewCoinPlugin::DefaultPlugin.new

    base_currencies = api.get_base_currencies
    base_currencies.size.should == 0

    usd_latest_conversion_date = api.get_latest_conversion_date('USD')
    usd_latest_conversion_date.should be_nil

    conversion_dates = api.get_conversion_dates('EUR')
    conversion_dates.size.should == 0

    rates = api.get_current_rates('USD')
    rates.size.should == 0

    rates = api.get_rates('USD', Time.now)
    rates.size.should == 0
  end
end
