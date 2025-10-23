# Decentralized Weather Insurance

A blockchain-based parametric insurance platform providing automatic payouts for adverse weather conditions based on verified oracle data.

## Overview

This system enables farmers and businesses to purchase insurance against specific weather events (excessive rain, drought, extreme temperatures) with automatic payouts when predetermined thresholds are exceeded. Built on Stacks using Clarity smart contracts with oracle integration for weather data verification.

## Real-World Use Case

Farmers can purchase insurance for excessive rainfall, with automatic payouts triggered when rainfall exceeds predefined thresholds verified by weather oracles. Agricultural losses exceed $100 billion annually worldwide, with parametric insurance reducing settlement time by 90% compared to traditional claims processing.

## Features

- **Parametric Policies**: Weather-based insurance with clearly defined trigger conditions
- **Oracle Integration**: Verified weather data from trusted external sources
- **Automatic Payouts**: Instant claims settlement when conditions are met
- **Multiple Coverage Types**: Rain, drought, temperature, wind, and custom parameters
- **Risk Pooling**: Distributed risk across multiple policyholders
- **Transparent Pricing**: Algorithm-based premium calculation
- **Claims Verification**: Immutable proof of weather conditions and payouts

## Smart Contracts

### weather-insurance
The core contract that handles:
- Policy creation and purchase
- Weather data verification from oracles
- Automatic payout calculation and distribution
- Premium collection and pool management
- Claims processing and settlement
- Risk assessment and pricing

## Technical Architecture

### Data Structures
- **Policy Registry**: Active policies with coverage parameters and thresholds
- **Weather Data Feed**: Oracle-provided weather measurements
- **Insurance Pool**: Collective funds for claim payouts
- **Claims History**: Complete record of triggered policies and payouts
- **Premium Calculations**: Risk-based pricing algorithms

### Key Functions
- `create-policy`: Define insurance coverage with weather parameters
- `purchase-policy`: Buy policy with premium payment
- `submit-weather-data`: Oracle function to provide verified weather data
- `process-claim`: Automatic claim verification and payout
- `calculate-premium`: Algorithm-based premium pricing
- `add-to-pool`: Liquidity provider deposits
- `withdraw-from-pool`: Liquidity provider withdrawals

## Getting Started

### Prerequisites
- [Clarinet](https://github.com/hirosystems/clarinet) installed
- Node.js and npm
- Stacks wallet for deployment
- Weather oracle integration (for production)

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd decentralized-weather-insurance

# Install dependencies
npm install

# Run contract checks
clarinet check

# Run tests
clarinet test
```

### Development

```bash
# Create a new contract
clarinet contract new <contract-name>

# Check contract syntax
clarinet check

# Run tests
npm test
```

## Usage Example

```clarity
;; Create a rainfall insurance policy
(contract-call? .weather-insurance create-policy
  "Excessive Rain Coverage"
  u100  ;; 100mm rainfall threshold
  u1000000  ;; 1M microSTX payout
  u5000)  ;; 30 day duration (blocks)

;; Purchase policy with premium
(contract-call? .weather-insurance purchase-policy
  u1
  u50000)  ;; Premium amount

;; Oracle submits weather data (when threshold exceeded)
(contract-call? .weather-insurance submit-weather-data
  u1
  u120)  ;; 120mm rainfall recorded

;; Automatic payout processing
(contract-call? .weather-insurance process-claim u1)
```

## Market Impact

The agricultural insurance sector faces critical challenges:
- High claims processing costs (20-30% of payouts)
- Lengthy settlement periods (6+ months)
- Dispute resolution complexities
- Limited coverage in developing regions
- Trust issues between insurers and farmers

This blockchain solution addresses these issues by:
- Eliminating subjective claims assessment
- Providing instant automated payouts (minutes vs months)
- Reducing administrative costs by 80%+
- Enabling transparent, verifiable coverage
- Expanding access to underserved markets

## Weather Parameters Supported

- **Rainfall**: Total precipitation over period
- **Temperature**: Min/max temperature thresholds
- **Drought**: Consecutive days without rain
- **Wind Speed**: Maximum sustained winds
- **Frost**: Temperature below freezing events
- **Custom**: Flexible parameter definitions

## Security Considerations

- Oracle data verification and source validation
- Multi-oracle consensus for critical payouts
- Time-locked policy modifications
- Insurance pool solvency monitoring
- Smart contract auditing for payout logic

## Roadmap

- [x] Core parametric insurance functionality
- [x] Oracle integration framework
- [ ] Multi-oracle consensus mechanism
- [ ] Reinsurance pool integration
- [ ] Mobile farmer applications
- [ ] Satellite data integration
- [ ] Cross-chain policy portability

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting pull requests.

## License

MIT License - see LICENSE file for details

## Contact

For questions, issues, or collaboration opportunities, please open an issue on GitHub.

## Acknowledgments

Built with Clarity on Stacks blockchain, bringing transparent and efficient parametric insurance to farmers and businesses worldwide.
