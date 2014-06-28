CREATE TABLE `bravenewcoin_ticker` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bravenewcoin_ticker` varchar(255),
  `bnc_index` varchar(255),
  `coin_id` varchar(255),
  `coin_name` varchar(255),
  `bnc_price_index_usd` varchar(255),
  `volume_24hr_usd` varchar(255),
  `total_supply` varchar(255),
  `mkt_cap_usd` varchar(255),
  `mkt_cap_24hr_pcnt` varchar(255),
  `price_24hr_pcnt` varchar(255),
  `vol_24hr_pcnt` varchar(255),
  `effective_date` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `bravenewcoin_ticker` (`coin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;