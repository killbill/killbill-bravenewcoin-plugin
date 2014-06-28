require 'spec_helper'

describe Killbill::BraveNewCoinPlugin::DefaultPlugin do

  before(:each) do
    Killbill::BraveNewCoinPlugin::Ticker.delete_all

    @plugin = Killbill::BraveNewCoinPlugin::DefaultPlugin.new
    @plugin.kb_apis = Killbill::Plugin::KillbillApi.new('bravenewcoin', {})
    @plugin.logger = Logger.new(STDOUT)
    @plugin.logger.level = Logger::INFO
    @plugin.conf_dir = File.expand_path(File.dirname(__FILE__) + '../../../../')
    @plugin.start_plugin
  end

  after(:each) do
    @plugin.stop_plugin
  end

  it 'should be able to fetch all rates' do
    Killbill::BraveNewCoinPlugin::Ticker.update_all(@plugin.logger)

    # Verify the data was updated - add a bit of time to avoid skewed clocks issues
    Killbill::BraveNewCoinPlugin::Ticker.latest_effective_date.should <= Time.now.utc + 1.minutes
    # Assuming the API is up-to-date...
    Killbill::BraveNewCoinPlugin::Ticker.latest_effective_date.should >= Time.now.utc - 5.minutes
    Killbill::BraveNewCoinPlugin::Ticker.supported_currencies.size.should >= 60

    @plugin.get_current_rates(:EUR).size.should == 0

    rates = @plugin.get_current_rates(:USD)
    rates.size.should == Killbill::BraveNewCoinPlugin::Ticker.supported_currencies.size
    btc_rate = rates.find { |r| r.currency == 'BTC' }
    btc_rate.should_not be_nil
    # Fragile, but good enough for now
    btc_rate.value.to_f.should >= 500
    btc_rate.value.to_f.should <= 1200
  end
end
