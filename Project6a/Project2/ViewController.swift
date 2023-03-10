//
//  ViewController.swift
//  Project2
//
//  Created by Tony Capelli on 22/02/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    
    var correctAnswer = 0
    var score = 0
    var questionAnswered = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(showScore))
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()

    }
    
    func askQuestion(action: UIAlertAction! = nil){
        countries.shuffle()
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        
        title = countries[correctAnswer].uppercased() + " Score: \(score)"
    }
    
    func restartGame(action: UIAlertAction! = nil){
        questionAnswered = 0
        score = 0
        askQuestion()
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        
        var title: String

        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong that's the \(countries[sender.tag].uppercased()) flag"
            score -= 1
        }
        
        questionAnswered += 1
        
        if questionAnswered == 10 {
            let ac  = UIAlertController(title: "You have answered 10 question", message: "Your final score is \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: restartGame))
            present(ac, animated: true)
        }
        
        let ac  = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
    }
    
    @objc func showScore() {
        let ac = UIAlertController(
                    title: "Current Score",
                    message: "Your score is \(score)",
                    preferredStyle: .alert)
                
                ac.addAction(UIAlertAction(
                    title: "Continiue",
                    style: .default,
                    handler: nil))
                
                present(ac, animated: true)
    }
}

