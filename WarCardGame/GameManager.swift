//
//  GameManager.swift
//  WarCardGame
//
//  Created by Student23 on 21/07/2024.
//
class GameManager {
    private let cards = [
        "1_of_clubs", "1_of_diamonds", "1_of_hearts", "1_of_spades",
        "2_of_clubs", "2_of_diamonds", "2_of_hearts", "2_of_spades",
        "3_of_clubs", "3_of_diamonds", "3_of_hearts", "3_of_spades",
        "4_of_clubs", "4_of_diamonds", "4_of_hearts", "4_of_spades",
        "5_of_clubs", "5_of_diamonds", "5_of_hearts", "5_of_spades",
        "6_of_clubs", "6_of_diamonds", "6_of_hearts", "6_of_spades",
        "7_of_clubs", "7_of_diamonds", "7_of_hearts", "7_of_spades",
        "8_of_clubs", "8_of_diamonds", "8_of_hearts", "8_of_spades",
        "9_of_clubs", "9_of_diamonds", "9_of_hearts", "9_of_spades",
        "10_of_clubs", "10_of_diamonds", "10_of_hearts", "10_of_spades",
        "11_of_clubs", "11_of_diamonds", "11_of_hearts", "11_of_spades",
        "12_of_clubs", "12_of_diamonds", "12_of_hearts", "12_of_spades",
        "13_of_clubs", "13_of_diamonds", "13_of_hearts", "13_of_spades"
    ]
    
    var deck: [String] = []
    var eastPlayerScore = 0
    var westPlayerScore = 0
    
    init() {
        shuffleDeck()
    }
    
    func shuffleDeck() {
        deck = cards.shuffled()
    }
    
    func drawCard() -> String {
        return  deck.removeFirst()
    }
    

    
    func updateScores(leftCard: String, rightCard: String) {
        let leftValue = getCardValue(cardName: leftCard)
        let rightValue = getCardValue(cardName: rightCard)
        
        if leftValue > rightValue {
            westPlayerScore += 1
        } else if rightValue > leftValue {
            eastPlayerScore += 1
        }
    }
    
    func getScores() -> (left: Int, right: Int) {
        return (westPlayerScore, eastPlayerScore)
    }
    
    
    func getCardValue(cardName: String) -> Int {
        let components = cardName.split(separator: "_")
        guard let rankString = components.first, let rank = Int(rankString) else { return 0 }
        return rank
    }

    
    func determineFinalWinner() -> String {
        if eastPlayerScore > westPlayerScore {
            return "East"
        } else if westPlayerScore > eastPlayerScore {
            return "West"
        } else {
            return "Tie"
        }
    }
    
}
