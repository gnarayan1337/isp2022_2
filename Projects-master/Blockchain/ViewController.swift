import UIKit
//mining RDS is essentially solving a mathematical problem. bitcoins come from an original account. when you mine a bitcoin you get RDS as a reward and it is a good way to issue this and provides an incentive to mine.
class ViewController: UIViewController {
    
    
    
    //0x684AD2adAce4dfA9EbB8fd43c96ff5766d591337
    let firstAccount = "0x684AD2adAce4dfA9EbB8fd43c96ff5766d591337"
    //0x963c39fD3aDB96e8770fAEF926DDfDCf77ed1488
    let secondAccount = "0x963c39fD3aDB96e8770fAEF926DDfDCf77ed1488"
    let bitcoinChain = Blockchain()
    //100 RDSs for every block mined
    let reward = 100
    var accounts: [String: Int] = ["GENESIS" : 100000]
    //if the transaction is invalid--the user is stupid-- message
    let invalidAlert = UIAlertController(title: "Invalid Transaction", message: "Please check the details of your transaction", preferredStyle: .alert)
    
    @IBOutlet var GifView: UIImageView!
    
    
    @IBOutlet weak var greenAmount: UITextField!
    @IBOutlet weak var redAmount: UITextField!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
//        GifView.loadGif(name: "gif")
        // genesis block call "transaction" function to send and receive RDS for the first transaction
        
        
        
    
        //view.backgroundColor = UIColor.clear
        
        transaction(from: "GENESIS", to: "\(firstAccount)", amount: 100, type: "genesis")
        transaction(from: "\(firstAccount)", to: "\(secondAccount)", amount: 50, type: "normal")
        chainState()
        self.invalidAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
    }
    //first function is transaction function it will receive 4 parameters
    //1. from what account it comes from, 2. to which account it goes to, 3. the ammount, and 4. what type of transaction
    func transaction(from: String, to: String, amount: Int, type: String) {
           if accounts[from] == nil {
               self.present(invalidAlert, animated: true, completion: nil)
               return
           } else if accounts[from]!-amount < 0 {
               self.present(invalidAlert, animated: true, completion: nil)
               return
           } else {
               accounts.updateValue(accounts[from]!-amount, forKey: from)
           }
           
           if accounts[to] == nil {
               accounts.updateValue(amount, forKey: to)
           } else {
               accounts.updateValue(accounts[to]!+amount, forKey: to)
           }
           
           if type == "genesis" {
               bitcoinChain.createGenesisBlock(data: "From: \(from); To: \(to); Amount: \(amount)RDS\n")
           } else if type == "normal" {
               bitcoinChain.createBlock(data: "From: \(from); To: \(to); Amount: \(amount)RDS\n")
           }
           
           if amount < 0 {
               self.present(invalidAlert, animated: true, completion: nil)
               return
           }
       }
    
    // what we are doing here is make a loop that prints the block number, block chain previous hash, and data
    func chainState() {
        for i in 0...bitcoinChain.chain.count-1 {
            print("\tBlock: \(bitcoinChain.chain[i].index!)\n\tHash: \(bitcoinChain.chain[i].hash!)\n\tPreviousHash: \(bitcoinChain.chain[i].previousHash!)\n\tData: \(bitcoinChain.chain[i].data!)")
        }
        
        redLabel.text = "Balance: \(accounts[String(describing: firstAccount)]!) RDS"
        greenLabel.text = "Balance: \(accounts[String(describing: secondAccount)]!) RDS"
        print(accounts)
        print(chainValidity())
    }
    
    //we interate over every block in the chain and we check to see if the previous hash of the block in front matches with the current block, and if it does, the chain is valid.
    func chainValidity() -> String {
        var isChainValid = true
        for i in 1...bitcoinChain.chain.count-1 {
            if bitcoinChain.chain[i].previousHash != bitcoinChain.chain[i-1].hash {
                isChainValid = false
            }
        }
        return "Chain is valid: \(isChainValid)\n"
    }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
  
    
  
    //Our 4 mining functions
    
    //reward for mining a block is 100RDS
    @IBAction func redMine(_ sender: Any) {
        transaction(from: "GENESIS", to: "\(firstAccount)", amount: 100, type: "normal")
        print("New block mined by: \(firstAccount)")
        chainState()
    }
    
    @IBAction func greenMine(_ sender: Any) {
        transaction(from: "GENESIS", to: "\(secondAccount)", amount: 100, type: "normal")
        print("New block mined by: \(secondAccount)")
        chainState()
    }
    //sending functions
    @IBAction func redSend(_ sender: Any) {
        if redAmount.text == "" {
            //check if red and green amount is empty if it is send invalid
            present(invalidAlert, animated: true, completion: nil)
        } else {
            transaction(from: "\(firstAccount)", to: "\(secondAccount)", amount: Int(redAmount.text!)!, type: "normal")
            print("\(redAmount.text!) RDS sent from \(firstAccount) to \(secondAccount)")
            chainState()
            redAmount.text = ""
        }
    }
    
    @IBAction func greenSend(_ sender: Any) {
        if greenAmount.text == "" {
            //check if red and green amount is empty if it is send invalid
            present(invalidAlert, animated: true, completion: nil)
        } else {
            transaction(from: "\(secondAccount)", to: "\(firstAccount)", amount: Int(greenAmount.text!)!, type: "normal")
            print("\(greenAmount.text!) RDS sent from \(secondAccount) to \(firstAccount)")
            chainState()
            greenAmount.text = ""
        }
    }


}

extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


