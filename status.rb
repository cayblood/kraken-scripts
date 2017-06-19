#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'kraken_client'
require 'awesome_print'
require 'money'

client = KrakenClient.load
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
