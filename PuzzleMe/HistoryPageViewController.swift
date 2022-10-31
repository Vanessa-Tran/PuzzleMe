//
//  HistoryPageViewController.swift
//  PuzzleMe
//
//  Created by Van Tran on 27/10/2022.
//

import UIKit

class CompletePuzzleCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
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
}

class HistoryPageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var puzzleCollectionView: UICollectionView!
    
    func numberOfSections(in puzzleCollectionView: UICollectionView) -> Int {
        print("Count of sections: " + String(1))
        return 1
    }

    func collectionView(_ puzzlecollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        print("Count for section " + String(section) + ": " + String(DataManager.shared.completedPuzzles.count))
        return DataManager.shared.completedPuzzles.count
    }

    func collectionView(_ puzzlecollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = puzzlecollectionView.dequeueReusableCell(withReuseIdentifier: "CompletePuzzleCell", for: indexPath) as! CompletePuzzleCell
        let puzzle: Puzzle = DataManager.shared.completedPuzzles[indexPath.row]
        
        //cell.imageView = puzzle.image
        cell.imageFromUrl(urlString: "https://easterbilby.net/compdle.wtf/computers/" + (puzzle.image) + String(5) + ".jpg")
        return cell
    }
    
    func collectionView(_ puzzlecollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Clicked on item " + String(indexPath.row))
        
        let clickedItem = DataManager.shared.completedPuzzles[indexPath.row]
        DataManager.shared.currentPuzzle = clickedItem
        
        //self.performSegue(withIdentifier: "showHistoryDetails", sender: nil)
    }

    func collectionView(_ puzzlecollectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath){}
  
    func configureCollectionView()
    {
       puzzleCollectionView!.dataSource = self
       puzzleCollectionView!.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        
       

        // Do any additional setup after loading the view.
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
