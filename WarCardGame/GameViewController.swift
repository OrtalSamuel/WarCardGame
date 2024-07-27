//
//  GameViewController.swift
//  WarCardGame
//
//  Created by Student23 on 18/07/2024.
//

import UIKit
class GameViewController: UIViewController
{
    
    @IBOutlet weak var westPlayerNameLable: UILabel!
    
    @IBOutlet weak var westPlayerScoreLable: UILabel!
    @IBOutlet weak var westCardImageView: UIImageView!
    
    
    
    @IBOutlet weak var eastPlayerNameLable: UILabel!
    @IBOutlet weak var eastPlayerScoreLable: UILabel!
    @IBOutlet weak var eastCardImageView: UIImageView!
    
    
    @IBOutlet weak var timerLable: UILabel!
    
    
    
    var playerName: String?
    var playerSide: String?
    
    //        var timerManager: TimerManager?
    //        var roundCount: Int = 0
    //        let maxRounds: Int = 10
    //        let roundDuration: TimeInterval = 8.0
    //        let cardDisplayDuration: TimeInterval = 3.0
    //        let cardBackDuration: TimeInterval = 1.0
    
    private var gameManager: GameManager!
    private var timer: TimerManager!
    private var isPlaying = false
    private var roundCount = 0
    private let maxRounds = 10
    private var roundDuration = 8
    private var winnerSide: String?
    private var winnerScore = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Player Name: \(playerName ?? "nil")")
        print("Player Side: \(playerSide ?? "nil")")
       
        //            startGame()
        
        
        gameManager = GameManager()
        timer = TimerManager(seconds: 7) { [weak self] in
            self?.playRound()
        }
        // Set initial state
        resetCardImages()
        setupGame()
        updateScoreLabels()
        
        timer.start()
    }
    
    func setupGame() {
        if let name = playerName {
            if playerSide == "East" {
                eastPlayerNameLable.text = name
                westPlayerNameLable.text = "PC"
            } else {
                westPlayerNameLable.text = name
                eastPlayerNameLable.text = "PC"
            }
            print("Game setup with playerName: \(name) and playerSide: \(playerSide ?? "nil")")
        } else {
            print("Game setup with nil playerName")
        }
    }
    
    //        func startGame() {
    //            timerManager = TimerManager(interval: roundDuration)
    //            timerManager?.startTimer { [weak self] in
    //                self?.startRound()
    //            }
    //    }
    
    //        @objc func startRound() {
    //            if roundCount >= maxRounds {
    //                goToResults()
    //                return
    //            }
    //
    //            roundCount += 1
    //            print("Round \(roundCount) started")
    //
    //            // Show the back of the cards for one second
    //            showBackOfCards()
    //            Timer.scheduledTimer(withTimeInterval: cardBackDuration, repeats: false) { [weak self] _ in
    //                self?.drawCards()
    //            }
    //        }
    private func playRound() {
        if roundCount >= maxRounds{
            timer.stop()
         
           resetCardImages()
            showWinner()
            return
        }
        resetCardImages()
        // Show "back" images for 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.showCards()
        }
    }
    
    private func showCards() {
        let leftCard = gameManager.drawCard()
        let rightCard = gameManager.drawCard()
        
        westCardImageView.image = UIImage(named: leftCard)
        eastCardImageView.image = UIImage(named: rightCard)
        
        // Show the drawn cards for 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.updateScores(leftCard: leftCard, rightCard: rightCard)
            self?.roundCount += 1
        }
    }
    
    
    private func updateScores(leftCard: String, rightCard: String) {
        gameManager.updateScores(leftCard: leftCard, rightCard: rightCard)
        updateScoreLabels()
        resetCardImages()
    }
    
    private func updateScoreLabels() {
        let scores = gameManager.getScores()
        westPlayerScoreLable.text = "\(scores.left)"
        eastPlayerScoreLable.text = " \(scores.right)"
    }
    
    private func resetCardImages() {
        westCardImageView.image = UIImage(named: "Back")
        eastCardImageView.image = UIImage(named: "Back")
    }
    
    private func showWinner() {
        print("Game Over. Go to Results.")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let resultVC = storyboard.instantiateViewController(withIdentifier: "Result") as? ResultViewController {
            let scores = gameManager.getScores()
            resultVC.westPlayerScore = scores.left
            resultVC.eastPlayerScore = scores.right
            resultVC.eastPlayerName = eastPlayerNameLable.text ?? ""
            resultVC.westPlayerName = westPlayerNameLable.text ?? ""
            resultVC.playerName = playerName ?? ""
            self.present(resultVC, animated: true)
        }
    }

    }
    
    
    
    //
    //        func showBackOfCards() {
    //            eastCardImageView.image = UIImage(named: "BACK")
    //            westCardImageView.image = UIImage(named: "BACK")
    //            timerLable.text = "\(roundDuration)"
    //        }
    //
    //        func drawCards() {
    //            guard let eastCard = gameManager.drawCard(), let westCard = gameManager.drawCard() else {
    //                goToResults()
    //                return
    //            }
    
    //            eastCardImageView.image = UIImage(named: eastCard)
    //            westCardImageView.image = UIImage(named: westCard)
    //
    //            let winner = gameManager.determineWinner(eastCard: eastCard, westCard: westCard)
    //            DispatchQueue.main.async { [weak self] in
    //                if winner == "East" {
    //                    self?.eastPlayerScoreLable.text = "\(self?.gameManager.eastPlayerScore ?? 0)"
    //                } else if winner == "West" {
    //                    self?.westPlayerScoreLable.text = "\(self?.gameManager.westPlayerScore ?? 0)"
    //                }
    //
    //                print("East Card: \(eastCard), West Card: \(westCard), Winner: \(winner)")
    //                print("East Score: \(self?.gameManager.eastPlayerScore ?? 0), West Score: \(self?.gameManager.westPlayerScore ?? 0)")
    //
    //                if self?.roundCount ?? 0 >= self?.maxRounds ?? 0 || self?.gameManager.deck.count ?? 0 <= 2 {
    //                    self?.goToResults()
    //                }
    //            }
    //        }
    //
    //        func goToResults() {
    //            // Stop the timer to avoid further round starts
    //            timerManager?.stopTimer()
    //            timerManager = nil
    //
    //            // Print the game end message only once
    //            print("Game Over. Go to Results.")
    //
    //            // Navigate to the results screen or update UI to show game over
    //            // performSegue(withIdentifier: "toResultViewController", sender: self)
    //        }
    ////
    ////        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    ////            if segue.identifier == "toResultViewController" {
    ////                if let resultViewController = segue.destination as? ResultViewController {
    ////                    resultViewController.eastPlayerScore = gameManager.eastPlayerScore
    ////                    resultViewController.westPlayerScore = gameManager.westPlayerScore
    ////                    resultViewController.winner = gameManager.determineFinalWinner()
    ////                }
    ////            }
    ////        }
    //    }

