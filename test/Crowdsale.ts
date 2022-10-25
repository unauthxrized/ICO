import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { AggregatorV3Mock, WorkshopToken, Crowdsale } from "../typechain-types";

describe("Crowdsale tests", async () => {
  let owner: SignerWithAddress
  let user: SignerWithAddress

  let aggregator: AggregatorV3Mock
  let token: WorkshopToken
  let crowdsale: Crowdsale

  before(async () => {
    [owner, user] = await ethers.getSigners();

    const AggregatorContract = await ethers.getContractFactory("AggregatorV3Mock")
    aggregator = await AggregatorContract.deploy()

    const TokenContract = await ethers.getContractFactory("WorkshopToken")
    token = await TokenContract.deploy()

    const Crowdsale = await ethers.getContractFactory("Crowdsale")
    crowdsale = await Crowdsale.deploy(aggregator.address, token.address)
  })

  it("Crowdsale setup balance", async () => {
    const balanceOfOwner = await token.balanceOf(owner.address)
    await token.transfer(crowdsale.address, balanceOfOwner)
    const balanceOfCrowdsale = await token.balanceOf(crowdsale.address)
    expect(balanceOfCrowdsale).to.equal(balanceOfOwner).to.equal(ethers.utils.parseEther("100000"))
  })

  it("Buy check", async () => {
    await crowdsale.connect(user).buyTokens({ value: ethers.utils.parseEther("10") })
    const usdBalance = await crowdsale.getUSDBalance()
    expect(usdBalance).to.equal(ethers.utils.parseEther("10"))

    const userBalance = await token.balanceOf(user.address)
    expect(userBalance).to.equal(ethers.utils.parseEther("100"))
  })
})