import UIKit

class ResultViewController: UIViewController
{
    
 
    
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var scoreLable: UILabel!
    
    
    var westPlayerScore: Int = 0
    var eastPlayerScore: Int = 0
    var westPlayerName: String = ""
    var eastPlayerName: String  = ""
    var playerName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if westPlayerScore > eastPlayerScore {
            winnerLabel.text = "WINNER: \(westPlayerName)"
            scoreLable.text = "Score: \(westPlayerScore)"
        } else if(westPlayerScore < eastPlayerScore) {
            winnerLabel.text = "WINNER: \(eastPlayerName)"
            scoreLable.text = "Score: \(eastPlayerScore)"
        }else{
            winnerLabel.text = "WINNER: PC"
            if westPlayerName == "PC"
            {
                scoreLable.text = "Score: \(westPlayerScore)"            }
            else{
                scoreLable.text = "Score: \(eastPlayerScore)"
            }
           
            
            
            
        }
    }
        
           
    @IBAction func backToMenu(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let menuVC = storyboard.instantiateViewController(withIdentifier: "Menu") as? ViewController {
            menuVC.playerName = playerName
            menuVC.returningFromGame = true
            self.present(menuVC, animated: true)
          
        }
            }
}
