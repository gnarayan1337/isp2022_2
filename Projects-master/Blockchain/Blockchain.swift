import UIKit

class Blockchain {
    //We made the block now we gotta link all of em together
    var chain = [Block]()
    
    //genesis block, first one
    func createGenesisBlock(data:String) {
        let genesisBlock = Block()
        genesisBlock.hash = genesisBlock.generateHash() //calling our function in Block.swift that generated a hash with nsuuid
        genesisBlock.data = data
        genesisBlock.previousHash = "0000" //the previous hash is 0000 because there is no hash before it
        genesisBlock.index = 0
        chain.append(genesisBlock)
    }
    
    //same thing as the genesis block functin except it adjusts the previous hash
    func createBlock(data:String) {
        let newBlock = Block()
        newBlock.hash = newBlock.generateHash()
        newBlock.data = data
        newBlock.previousHash = chain[chain.count-1].hash
        newBlock.index = chain.count //number of block
        chain.append(newBlock)
    }
    
    
}
