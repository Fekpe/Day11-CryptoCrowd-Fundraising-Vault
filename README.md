# 🚀 CryptoCrowd – Milestone-Based Crowdfunding Vault

A decentralized crowdfunding smart contract where:
- Creators launch fundraising campaigns.
- Contributors deposit ETH until campaign deadline.
- Funds only released if the funding goal is met.
- If goal fails: contributors can claim refunds.

---

## 🔑 Core Features
| Feature | Description |
|---------|-------------|
| Create Campaign | Users define goal & deadline |
| Fund Campaign | Anyone can send ETH & support |
| Claim Funds | Only if goal was met after deadline |
| Refunds | Automatic refunds if goal not reached |
| Escrow Logic | Funds securely locked until conditions met |
| Custom Errors | Gas-efficient Solidity errors |
| Modular Tests & Scripts | Foundry-based project structure |

---

## 🧱 Project Structure (Day11-CryptoCrowd)
```
/Day11-CryptoCrowd
 ├── src/
 │   └── CryptoCrowd.sol
 ├── test/
 │   └── CryptoCrowd.t.sol       ← (Day 12)
 ├── script/
 │   ├── DeployCrowd.s.sol       ← (Day 12)
 │   └── CreateCampaign.s.sol
 ├── frontend/                   ← (Day 13)
 └── README.md
```

---

## ⚙️ Setup — Initialize Foundry Project

```bash
forge init Day11-CryptoCrowd
cd Day11-CryptoCrowd
forge install OpenZeppelin/openzeppelin-contracts
```

---

## 🛠 Build & Compile

```bash
forge build
```

---

## 🧪 Test (From Day 12)

```bash
forge test
```

---

## 🚀 Deploy (From Day 12)

```bash
forge script script/DeployCrowd.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```

---

## 🌍 Next Step — Day 12 (Tomorrow)
| Day | Focus |
|-----|-------|
| Day 11 | Smart contract (core logic) |
| Day 12 | Test cases + Deploy scripts |
| Day 13 | Frontend (Next.js + viem + MetaMask) |

---

🛠 **Day 11 of 30 — Project Mode Activated 🚀**