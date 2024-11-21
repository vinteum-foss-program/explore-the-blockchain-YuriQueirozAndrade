# Which tx in block 257,343 spends the coinbase output of block 256,128?
get_block_transaction() {
  bitcoin-cli getblock $(bitcoin-cli getblockhash $1) | jq '.tx'
}

coinbase_transaction=$(get_block_transaction 256128 | jq -r '.[0]')
transaction_array=($(get_block_transaction 257343 | jq -r '.[1:].[]'))

found=false

for transaction in "${transaction_array[@]}"
do

  raw_transaction=$(bitcoin-cli getrawtransaction "$transaction" true 2>/dev/null)
  if [ $? -ne 0 ]; then
    continue
  fi

  txid_array=($(echo "$raw_transaction" | jq -r '.vin[].txid'))

  for txid in "${txid_array[@]}"
  do
    if [ "$txid" == "$coinbase_transaction" ]; then
      found=true
      break
    fi
  done

  if [ "$found" = true ]; then
    break
  fi
done

echo "$transaction"
