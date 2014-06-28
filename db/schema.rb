require 'active_record'

ActiveRecord::Schema.define(:version => 20140611853636) do
  create_table "bravenewcoin_ticker", :force => true do |t|
    t.string   "bnc_index"
    t.string   "coin_id",              :null => false
    t.string   "coin_name"
    t.string   "bnc_price_index_usd"
    t.string   "volume_24hr_usd"
    t.string   "total_supply"
    t.string   "mkt_cap_usd"
    t.string   "mkt_cap_24hr_pcnt"
    t.string   "price_24hr_pcnt"
    t.string   "vol_24hr_pcnt"
    t.datetime "effective_date",       :null => false
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index(:bravenewcoin_ticker, :coin_id)
end



