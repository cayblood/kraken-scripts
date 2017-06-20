#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'kraken_client'
require 'awesome_print'
require 'money'

client = KrakenClient.load
ticker_data = client.public.ticker('ETHUSD')
open_orders = client.private.open_orders
last_value = ticker_data['XETHZUSD']['c'][0].to_f * 100
volume = open_orders['open'].first[1]['vol'].to_f
total_at_last = last_value * volume
puts "Current price = #{Money.us_dollar(last_value).format} - #{Money.us_dollar(total_at_last).format}"
open_orders = client.private.open_orders
open_orders['open'].each do |key, val|
  stopprice = val['stopprice'] ? " stopprice = #{Money.us_dollar(val['stopprice'].to_f * 100).format}" : nil
  sale_value = val['stopprice'].to_f * val['vol'].to_f * 100 if stopprice
  if sale_value
    sale_value = " - #{Money.us_dollar(sale_value).format}"
  else
    amount = val['descr']['price'].to_f * val['vol'].to_f * 100
    sale_value = " - #{Money.us_dollar(amount).format}"
  end
  puts "#{key} = #{val['descr']['order']}#{stopprice}#{sale_value}"
end
