//
//  JokesViewController.swift
//  QuarantineApp
//
//  Created by Roope Vaarama on 21.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit

class JokesViewController: UIViewController, JokeAPIDelegate {
    
    func newData(_ jokeInfo: JokeInfo?) {
        DispatchQueue.main.async {
            print("newData in viewcontroller")
            if(jokeInfo?.setup == nil) {
                self.setupLabel.text = jokeInfo?.joke
            } else {
                self.setupLabel.text = jokeInfo?.setup
            }
            print(jokeInfo?.setup)
            self.deliveryLabel.text = jokeInfo?.delivery
        }
    }
    @IBOutlet var navigationbar: UINavigationItem!
    var nextjoke = NSLocalizedString("Next Joke", comment: "")
    var jokes = NSLocalizedString("Jokes", comment: "")
    @IBOutlet var button: UIButton!
    @IBOutlet var setupLabel: UILabel!
    @IBOutlet var deliveryLabel: UILabel!
    @IBAction func nextButton(_ sender: UIButton) {
        nextJoke()
    }
    
    
    var number: Int = 1
    var blacklist: String = "religious,political,racist"
    override func viewDidLoad() {
        super.viewDidLoad()
        button.setTitle(nextjoke, for: .normal)
        navigationbar.title = jokes
        getJokes()
    }
    
    func nextJoke(){
        number+=1
        getJokes()
    }
    
    func getJokes(){
        let jokeApi = JokeAPI()
        jokeApi.url = "https://sv443.net/jokeapi/v2/joke/Any?blacklistFlags=\(blacklist)&idRange=1-184"
        jokeApi.jokeAPIDelegate = self
        jokeApi.getData()
        
    }
}
