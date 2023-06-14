import { AptosAccount, AptosClient, CoinClient, HexString } from "aptos";

export class AptosBootingManager {
  public static currentInstance: AptosBootingManager | undefined;

  public static APTOS_FAUCET_URL = "https://faucet.testnet.aptoslabs.com";
  public static APTOS_NODE_URL = "https://fullnode.testnet.aptoslabs.com";

  public readonly client: AptosClient;
  public resourceAccountAddress = "";
  private deployerAccount: AptosAccount | undefined;

  private managedAccounts: AptosAccount[] = [];

  constructor(readonly handler = require("node:child_process")) {
    // initialize client first
    this.client = new AptosClient(AptosBootingManager.APTOS_NODE_URL);
  }

  /**
   * @notice Singleton to get current instance
   */
  public static getInstance(): AptosBootingManager {
    // if available then return current instance
    if (this.currentInstance) {
      return this.currentInstance;
    }

    this.currentInstance = new AptosBootingManager();
    return this.currentInstance;
  }

  /**
   * @notice get deployer account
   */
  public getDeployerAccount() {
    if (this.deployerAccount) {
      return this.deployerAccount;
    }

    this.deployerAccount = new AptosAccount();
    this.managedAccounts.push(this.deployerAccount);

    return this.deployerAccount;
  }

  /**
   * @notice Prepare program to be ready for test
   */
  public async deployProgram(
    deployerAccount: string,
    resourceAccount: string,
    privateKey: string
  ) {
    /**
     * @dev Funding account
     */
    this.handler.execSync(
      [
        "aptos",
        "account",
        "fund-with-faucet",
        `--account ${resourceAccount}`,
        `--faucet-url ${AptosBootingManager.APTOS_FAUCET_URL}`,
        `--url ${AptosBootingManager.APTOS_NODE_URL}`,
      ].join(" "),
      { stdio: "inherit" }
    );

    /**
     * @dev Deploy program
     */
    this.handler.execSync(
      [
        "aptos",
        "move",
        "publish",
        "--assume-yes",
        `--private-key ${privateKey}`,
        `--sender-account ${resourceAccount}`,
        `--named-addresses hamsterpocket=${resourceAccount},deployer=${deployerAccount}`,
        `--url ${AptosBootingManager.APTOS_NODE_URL}`,
      ].join(" "),
      { stdio: "inherit" }
    );

    /**
     * @dev Assign resource account
     */
    this.resourceAccountAddress = resourceAccount;
  }

  /**
   * @notice Funding faucet to an account
   * @param addressHex
   */
  public async fundingWithFaucet(addressHex: string): Promise<void> {
    return Promise.resolve(
      this.handler.execSync(
        [
          "aptos",
          "account",
          "fund-with-faucet",
          `--account ${addressHex}`,
          `--faucet-url ${AptosBootingManager.APTOS_FAUCET_URL}`,
          `--url ${AptosBootingManager.APTOS_NODE_URL}`,
        ].join(" "),
        { stdio: "inherit" }
      )
    );
  }

  /**
   * @notice Create and fund account
   */
  public async createAndFundAccount() {
    const account = new AptosAccount();

    // push to account registry
    this.managedAccounts.push(account);

    // funding account
    await this.fundingWithFaucet(account.address().hex());

    return account;
  }

  /**
   * @dev Collect all fees
   * @param target
   */
  public async collectAllFaucet(target: HexString) {
    await Promise.all(
      this.managedAccounts.map(async (account) => {
        const coinClient = new CoinClient(this.client);

        return coinClient.transfer(
          account,
          target,
          (await coinClient.checkBalance(account)) - BigInt(1e7)
        );
      })
    );
  }
}
