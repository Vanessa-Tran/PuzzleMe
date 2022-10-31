//
//  FinishPageViewController.swift
//  PuzzleMe
//
//  Created by Van Tran on 25/10/2022.
//

import UIKit

class FinishPageViewController: UIViewController {
    var currentPuzzle: Puzzle! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentPuzzle = DataManager.shared.currentPuzzle!
        
        let urlStr = "https://easterbilby.net/compdle.wtf/computers/" + (currentPuzzle.image) + String(5) + ".jpg"
        imageFromUrl(urlString: urlStr)
        
        if (currentPuzzle.isSucceeded == true) {
            
            completionText.text = "CONGRATULATIONS!"
            subtitle.text = "YOU WON"
        }
        else {
            
            completionText.text = "YOU LOST."
            subtitle.text = "TRY AGAIN NEXT TIME!"
        }
        
        computerName.setTitle(currentPuzzle.name, for: .normal)
        
        durationTime.text = getDurationText()
        
        noOfTries.text = String(currentPuzzle.numberOfAttempts)
        
        photographer.setTitle( currentPuzzle.photographer, for: .normal)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        
        completionDate.text = dateFormatter.string(from: currentPuzzle.puzzleDate)
        
        licence.text = currentPuzzle.license
    }
    
    func getDurationText() -> String {
        return String(format: "%.2f seconds", currentPuzzle.elapsedTime)
    }
    
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var durationTime: UILabel!
    @IBOutlet weak var completionText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var computerName: UIButton!
    
    @IBOutlet weak var noOfTries: UILabel!
    @IBOutlet weak var completionDate: UILabel!
    @IBOutlet weak var photographer: UIButton!
    @IBOutlet weak var licence: UILabel!
    
    @IBAction func compNameClicked(_ sender: Any) {
        guard let url = URL(string: currentPuzzle.computer_link) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func photographerClicked(_ sender: Any) {
        guard let url = URL(string: currentPuzzle.photographer_link) else { return }
        UIApplication.shared.open(url)
    }
    
    //TODO: test this, add documentation to this.
    @IBAction func share(_ sender: Any) {
        let text = "I have completed the puzzle for " + currentPuzzle.name + " in " + getDurationText()
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //TODO: move this to a shared file
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
