# Only one single output remains unspent from block 123,321. What address was it sent to?
get_block_transaction() {
  bitcoin-cli getblock $(bitcoin-cli getblockhash $1) | jq '.tx'
}

transaction_array=($(get_block_transaction 123321 | jq -r '.[]'))

for transaction in ${transaction_array[@]}
do
  vout_count=($(bitcoin-cli getrawtransaction $transaction true | jq '.vout[].n'))

  for vout in ${vout_count[@]}
  do
    address=$(bitcoin-cli gettxout $transaction $vout | jq -r '.scriptPubKey.address')
    if [[ ! -z "${address}" ]]; then
      echo -e $address
      break
    fi
  done
done
