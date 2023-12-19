# Testworld Mission 2.0 -- MINA

> [Testworld Mission 2.0: Protocol Performance Testing Program Terms and Conditions](https://minaprotocol.com/testworld-2-protocol-performance-tcs) [October 17, 2023] ~= 3 Epochs <br/>
> [Testworld Mission 2.0 Protocol Performance Testing – Program Extension Details](https://minaprotocol.com/blog/testworld-mission-2-0-program-extension-details) [December 18th, 2023 - January 22nd, 2024] 

## [Block producer](block-producer)
* Run 2 Mina nodes on a cloud provider or hosted solution of your choice from the start until the end of the protocol performance testing
  > ✅✅ 
* Run the latest Mina Node version (the Latest Mina Node version will be shared on Discord before the protocol performance testing starts) with all the required flags
  > ✅ [Berkeley Testnet Release 2.0.0rampup7 (ITN RC3)](https://github.com/MinaProtocol/mina/releases/tag/2.0.0rampup7) <br/>
  > ✅ [Berkeley Testnet Release 2.0.0rampup6 (ITN RC2)](https://github.com/MinaProtocol/mina/releases/tag/2.0.0rampup6) <br/>
  > ✅ [Berkeley Testnet Release 2.0.0rampup5 (ITN)](https://github.com/MinaProtocol/mina/releases/tag/2.0.0rampup5) <br/><br/>
  > ✅✅ [Run your nodes with --itn-max-logs 10000 flag](https://github.com/MinaProtocol/mina/releases/tag/2.0.0rampup7) <br/>
  > ✅✅ [Removing the --max-connections 200 flag](https://github.com/o1-labs/docs2/pull/719)
* Upgrade to a new Mina Node version within 24 hours if required
* Ensure a high uptime % during the testing (a minimum of 90% uptime is required) as monitored by the snark-work-based uptime system
  > **Baseline** D60+ <br/>
  > 🟩🟩🟩🟨🟨🟨🟨🟨🟧🟧 <br/>
  > 🟧🟨🟩🟩🟨🟩🟩🟩🟩🟩 <br/>
  > 🟩🟨🟩🟩🟩🟩🟩🟩🟩🟧 <br/>
  > 🟩🟩🟩🟩🟩🟩🟧🟩🟩🟩 <br/>
  > 🟩🟩🟩🟨🟨🟩🟩🟩🟩🟩 <br/>
  > 🟨🟨🟩🟩🟩🟩🟩🟩🟧🟧 <br/>
  >  **Extension** D4<br/>
  > 🟨🟩🟩🟩⬜⬜⬜⬜⬜⬜ <br/>
  > ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ <br/>
  > ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ <br/>
  > ⬜⬜⬜⬜⬜
* The Mina Nodes should be configured to restart automatically on crash and to persist the configuration directory across restarts
  > ✅ There will be random node restarts via the orchestrator once every 6 hours.
* The Block Producer is expected to raise any abnormal behaviour during the protocol performance testing on Github, using the labels “Testworld-2-0-protocol-performance-testing” and “Testworld-2-0-block-producer”
* Configure the Mina Node correctly – configuration instructions will be shared before the protocol performance testing starts

    
