module Killbill
  module BraveNewCoinPlugin
    class DefaultPlugin < Killbill::Plugin::Currency

      def start_plugin
        super

        config_file = Pathname.new("#{@conf_dir}/bravenewcoin.yml").expand_path
        @config = YAML.load_file(config_file.to_s)
        ActiveRecord::Base.establish_connection(@config[:database])

        # Refresh data every 5 minutes
        Thread.every(300) { Ticker.update_all(@logger) }
      end

      # Return DB connections to the Pool if required
      def after_request
        ActiveRecord::Base.connection.close
      end

      # All the base rates supported
      def get_base_currencies(options = {})
        # TODO Expand the Currency enum
        Ticker.supported_currencies
      end

      # Last conversion date for a given currency
      def get_latest_conversion_date(base_currency, options = {})
        Ticker.latest_effective_date(base_currency)
      end

      # Conversions dates for that currency (ordered)
      def get_conversion_dates(base_currency, options = {})
        Ticker.effective_dates(base_currency)
      end

      # List of rates for that currency
      def get_current_rates(base_currency, options = {})
        get_rates(base_currency, nil, options)
      end

      # List of rates for that currency and that conversion date
      def get_rates(base_currency, conversion_date, options = {})
        # BraveNewCoin only supports USD for now
        return [] if base_currency != :USD

        Ticker.all_rates(conversion_date).map { |t| build_rate(t) }
      end

      private

      def build_rate(ticker, base_currency = :USD)
        rate = Killbill::Plugin::Model::Rate.new
        rate.base_currency = base_currency
        rate.currency = ticker.coin_id
        rate.value = ticker.bnc_price_index_usd
        rate.conversion_date = ticker.effective_date
        rate
      end
    end
  end
end
