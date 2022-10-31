//
//  ViewController.swift
//  PuzzleMe
//
//  Created by Van Tran on 24/10/2022.
//

import UIKit

class HomePageViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func receivedPuzzle(_ data: Data?, _ response: URLResponse?, _ error:  Error?) {
        print("finished network call")
        let str = String(decoding: data!, as: UTF8.self)
        print(str)
        do {
            let jsonObj = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
            
            let puzzle = Puzzle.fromNSDictionary(jsonObj, date: Date.now)
                
            DispatchQueue.main.async{
                DataManager.shared.currentPuzzle = puzzle
                
                self.performSegue(withIdentifier: "playing", sender: nil)
            }
        } catch let error {
            print("Cannot create json obj:", error)
        }
    }
    
    @IBAction func playClicked(_ sender: UIButton) {
        //sender.setTitle("clicked", for: .normal)
        print("initiating network call")
        let url = URL(string: "https://easterbilby.net/compdle.wtf/api.php")
        let session = URLSession.shared
        session.dataTask(with: url!, completionHandler: receivedPuzzle).resume()
    }

}

