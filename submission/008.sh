# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`
bitcoin-cli decodescript $(bitcoin-cli getrawtransaction  e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163 true | jq -r '.vin[].txinwitness[2]') | jq -r '.asm | split(" ") | .[1]'
