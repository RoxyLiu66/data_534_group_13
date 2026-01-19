# data_534_group_13
data_534_group_13,created by Avalvir Sekhon and Zihuan
Api link is https://www.exchangerate-api.com/


Intended Outcome: 
Develop an R package called EasyExchange designed to simplify the acquisition of exchange rate data. Users can simply enter a currency code (e.g., USD, CNY) to get the latest exchange rates, historical rates, or perform pair conversions.

Core Features:
get_latest_rates ("USD"): Get the latest exchange rate for a specified currency relative to all other currencies.
get_historical_rate("USD", "2023-01-01"): Get historical exchange rates for a specific date.
convert_currency (from, to, amount): Directly convert the amount between the two currencies.
