//
//  PuzzlePageViewController.swift
//  PuzzleMe
//
//  Created by Van Tran on 25/10/2022.
//

import UIKit

class PuzzlePageViewController: UIViewController {
    var currentPuzzle: Puzzle? = nil
    var lastIDNum: Int16 = 0
    var startTime = CACurrentMediaTime();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPuzzle = DataManager.shared.currentPuzzle
        // Do any additional setup after loading the view.
        
        let urlStr = "https://easterbilby.net/compdle.wtf/computers/" + (currentPuzzle!.image) + String(lastIDNum) + ".jpg"
        imageFromUrl(urlString: urlStr)
        
        startTime = CACurrentMediaTime();
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var guessTextField: UITextField!
    
    func imageFromUrl(urlString: String) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    self.imageView.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        
        
        let elapsedTime = CACurrentMediaTime() - self.startTime
        let numberOfAttempts: Int16 = self.lastIDNum + 1
        
        if ((currentPuzzle!.name).lowercased() ==  guessTextField.text?.lowercased()){
            print("Succeeded")
            currentPuzzle?.isSucceeded = true
            currentPuzzle?.elapsedTime = elapsedTime
            currentPuzzle?.numberOfAttempts = numberOfAttempts
            
            DataManager.shared.completePuzzle(currentPuzzle!)
            
            self.performSegue(withIdentifier: "finished", sender: nil)
            
            
            var viewControllers = self.navigationController?.viewControllers
            viewControllers!.remove(at: viewControllers!.count - 2)
            self.navigationController?.setViewControllers(viewControllers!, animated: false)
        }
        else if (lastIDNum == 4) {
            currentPuzzle?.isSucceeded = false
            currentPuzzle?.elapsedTime = elapsedTime
            currentPuzzle?.numberOfAttempts = numberOfAttempts
            
            DataManager.shared.completePuzzle(currentPuzzle!)
            
            self.performSegue(withIdentifier: "finished", sender: nil)
        }
        else {
            print("Loserrr!")
            lastIDNum += 1
            let urlStr = "https://easterbilby.net/compdle.wtf/computers/" + (currentPuzzle!.image) + String(lastIDNum) + ".jpg"
            imageFromUrl(urlString: urlStr)
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
