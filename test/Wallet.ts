import { expect } from 'chai'
import { ethers } from 'hardhat'
import { Wallet } from '../typechain-types'

describe('Wallet  ', function () {
    let wallet: Wallet

    before(async function () {
        ;[this.owner, this.addr1, ...this.addrs] = await ethers.getSigners()
        const Wallet = await ethers.getContractFactory('Wallet')
        let owners: string[] = [this.owner.address, this.addr1.address]

        wallet = await Wallet.deploy()
    })

    describe('Check balance', function () {
        it('initial balance', async function () {
            expect(await ethers.provider.getBalance(wallet.address)).to.equal(0)
        })
    })

    describe('Withdraw', function () {
        it('new contract', async function () {
            await expect(wallet.withdraw(this.addr1.address, 10)).to.be.revertedWith(
                'wallet: not enough funds to withdraw'
            )
        })

        it('withdraw no owner', async function () {
            await expect(wallet.connect(this.addr1).withdraw(this.owner.address, 10)).to.be.revertedWith(
                'Ownable: caller is not the owner'
            )
        })

        it('withdraw', async function () {
            await this.owner.sendTransaction({
                to: wallet.address,
                value: 100,
            })
            await wallet.withdraw(this.owner.address, 100)
            expect(await ethers.provider.getBalance(wallet.address)).to.equal(0)
        })
    })
})
