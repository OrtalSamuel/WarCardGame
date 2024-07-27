import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var eastImageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var westImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    let locationManager = CLLocationManager()
    let midpointLatitude: Double = 34.817549168324334
    
        var hasLocation: Bool = false
        var playerName: String?
        var playerSide: String?
        var returningFromGame: Bool = false

        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            setupLocationManager()
            nameTextField.delegate = self
        }
        func setupUI() {
            startButton.isHidden = true
            startButton.isEnabled = false
            nameTextField.isHidden = false

            if returningFromGame, let name = playerName {
                titleLable.text = "Welcome, \(name)"
                nameTextField.text = name
            } else {
                titleLable.text = "Insert your name"
                nameTextField.text = ""
            }
        }

        func setupLocationManager() {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }

        @IBAction func startButtonTapped(_ sender: UIButton) {
            if let name = nameTextField.text, !name.isEmpty {
                playerName = name // Update playerName here
                print("Start button tapped with name: \(playerName ?? "nil") and side: \(playerSide ?? "nil")")
             //   performSegue(withIdentifier: "toGameViewController", sender: self)
            } else {
                print("Start button tapped but name is empty")
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "Game") as? GameViewController {
                vc.playerName = playerName // Pass the player's name to the next view controller
                vc.playerSide = playerSide
                self.present(vc, animated: true)
                
            }
        }
        
        


        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            print("didUpdateLocationd")
            if let location = locations.last {
                updateUIBasedOnLocation(location.coordinate.latitude)
                locationManager.stopUpdatingLocation()
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                print("got Location: \(lat) \(lon)")
            }
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Failed to get location: \(error.localizedDescription)")
        }

        func updateUIBasedOnLocation(_ latitude: Double) {
            if latitude > midpointLatitude {
                // East side
                eastImageView.isHidden = false
                westImageView.isHidden = true
                playerSide = "East"
                print("East")
            } else {
                // West side
                eastImageView.isHidden = true
                westImageView.isHidden = false
                playerSide = "West"
                print("West")
            }
            hasLocation = true
            locationManager.stopUpdatingLocation()
            checkIfStartButtonShouldBeEnabled()
            
        }

        func checkIfStartButtonShouldBeEnabled() {
            if hasLocation, let name = playerName, !name.isEmpty, titleLable.text == "Welcome, \(name)" {
                startButton.isEnabled = true
                startButton.isHidden = false
            } else {
                startButton.isEnabled = false
                startButton.isHidden = true
            }
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let text = textField.text, let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)
                startButton.isEnabled = hasLocation && !updatedText.isEmpty && titleLable.text == "Welcome, \(updatedText)"
                startButton.isHidden = !(hasLocation && !updatedText.isEmpty && titleLable.text == "Welcome, \(updatedText)")
            }
            return true
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            if let name = textField.text, !name.isEmpty {
                playerName = name // Update playerName here
                titleLable.text = "Welcome, \(name)"
                nameTextField.isHidden = true
                checkIfStartButtonShouldBeEnabled()
            }
            return true
        }

        @IBAction func unwindToFirstScreen(segue: UIStoryboardSegue) {
            if  let resultVC = segue.source as? ResultViewController
            {
                playerName = resultVC.playerName
                returningFromGame = true
                setupUI()
            }
        }
    }
