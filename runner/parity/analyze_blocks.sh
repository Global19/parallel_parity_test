#!/bin/bash

set -eu

start=$1
end=$2

[ -f /usr/local/bin/jq ] || {
  curl -L https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 > /usr/local/bin/jq
  chmod a+x /usr/local/bin/jq
}

parity_endpoint=${PARITY_ENDPOINT:-localhost:8540}

for i in $(seq $start $end); do
    curl -d "{\"method\":\"eth_getBlockByNumber\",\"params\":[\"$i\",true],\"id\":1,\"jsonrpc\":\"2.0\"}" \
         -H "Content-Type: application/json" \
         -X POST \
         -o "block-$i.json" \
         $parity_endpoint
done

for i in $(seq $start $end); do
    hex_timestamp=$(jq -r '.result.timestamp' "block-$i.json")
    timestamp=$(printf '%d\n' $hex_timestamp)
    n_transactions=$(jq -r '.result.transactions | length' "block-$i.json")

    echo "$timestamp,$n_transactions"
done
