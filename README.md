

how to run locally:
```
docker run -it --rm node:22 bash
apt update
curl -L https://foundry.paradigm.xyz | bash
source ~/.bashrc
foundryup
git clone https://github.com/akshaykripalani/subvisual-academy
cd subvisual-academy
git submodule update --init --recursive
forge test
```

in another terminal (use docker ps and -it bash):
```
anvil
```


(since anvil provides a default first pk and contact address, export those)

back in origianl terminal:

```
export PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
export RPC_URL=http://127.0.0.1:8545
export CONTRACT_ADDRESS=0x5FbDB2315678afecb367f032d93F642f64180aa3

forge script script/Guestbook.s.sol:GuestbookScript \
  --rpc-url $RPC_URL \
  --broadcast \
  --private-key $PRIVATE_KEY
```


Test commands:
1. Get total Message count
```
cast call $CONTRACT_ADDRESS \
  "getMessageCount()(uint256)" \
  --rpc-url $RPC_URL
```

2. Send a message
```
cast send $CONTRACT_ADDRESS \
  "writeToBook(string)" "hello from my cli" \
  --rpc-url $RPC_URL \
  --private-key $PRIVATE_KEY
```

3. Read message
```
cast call $CONTRACT_ADDRESS \
  "getMessageById(uint256)((uint256,address,uint256,string))" 1 \
  --rpc-url $RPC_URL
```

To run frontend:
```
cd frontend/subvisual-frontend
npm install
echo "NEXT_PUBLIC_CONTRACT_ADDRESS=$CONTRACT_ADDRESS" > /.env.local
npm run dev
```