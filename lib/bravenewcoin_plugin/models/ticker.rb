module Killbill
  module BraveNewCoinPlugin
    class Ticker < ActiveRecord::Base

      self.table_name = 'bravenewcoin_ticker'

      class << self

        def all_rates(effective_date=nil)
          if effective_date.nil?
            # Get latest data - assume the updated date is shared across all coins
            where(:effective_date => latest_effective_date)
          else
            # TODO
            []
          end
        end

        def supported_currencies
          select(:coin_id).distinct
        end

        def effective_dates(currency)
          select(:effective_date).where(:coin_id => currency).order(:effective_date)
        end

        def latest_effective_date(currency=nil)
          if currency.nil?
            maximum(:effective_date)
          else
            where(:coin_id => currency).maximum(:effective_date)
          end
        end

        # TODO Take a lock for concurrency
        def update_all(logger=Logger.new)
          all_coins = get_latest_coins_ticker

          # Check if the data is up-to-date
          effective_date = Time.at(all_coins['time_stamp']).utc.to_datetime
          if !latest_effective_date.nil? and latest_effective_date >= effective_date
            logger.info "Skipping update: latest_effective_date is #{latest_effective_date} but BraveNewCoin time_stamp is #{effective_date}"
            return
          end

          logger.info "Found #{all_coins['ticker'].size} coins to update"
          all_coins['ticker'].each do |coin_data|
            # We store raw data as Strings for now as the API isn't fully documented yet
            ticker = new(coin_data)
            # Make sure to store UTC only
            ticker.effective_date = effective_date
            logger.warn "Unable to store data for #{coin_data}" unless ticker.save
          end
        end

        private

        def get_latest_coins_ticker
          http = Net::HTTP.new('api.bravenewcoin.com', 80)
          req = Net::HTTP::Get.new('/ticker/bnc_ticker_all.json', {'User-Agent' => 'killbill-bravenewcoin-plugin'})
          response = http.request(req)
          JSON.parse(response.body)
        end
      end
    end
  end
end
