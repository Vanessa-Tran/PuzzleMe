//
//  DataManager.swift
//  PuzzleMe
//
//  Created by Van Tran on 24/10/2022.
//

import UIKit
import CoreData

class Puzzle {
    var name: String
    var image: String
    var photographer: String
    var license: String
    var photographer_link: String
    var computer_link: String
    var isSucceeded: Bool
    var elapsedTime: Double
    var puzzleDate: Date
    var numberOfAttempts: Int16
    
    init( name: String,
          image: String,
          photographer: String,
          license: String,
          photographer_link: String,
          computer_link: String,
          isSucceeded: Bool,
          elapsedTime: Double,
          puzzleDate: Date,
          numberOfAttempts: Int16
    ) {
        
        self.name = name
        self.image = image
        self.photographer = photographer
        self.license = license
        self.photographer_link = photographer_link
        self.computer_link = computer_link
        self.isSucceeded = isSucceeded
        self.elapsedTime = elapsedTime
        self.puzzleDate = puzzleDate
        self.numberOfAttempts = numberOfAttempts
    }
    
    static func fromNSDictionary(_ dict: NSDictionary, date: Date) -> Puzzle {
        
        return Puzzle(
            name:              dict["name"]              as! String,
            image:             dict["image"]             as! String,
            photographer:      dict["photographer"]      as! String,
            license:           dict["license"]           as! String,
            photographer_link: dict["photographer_link"] as! String,
            computer_link:     dict["computer_link"]     as! String,
            isSucceeded:       false,
            elapsedTime:       0.0,
            puzzleDate:        date,
            numberOfAttempts:  0
            
        )
    }
    
    static func fromManagedObject(_ obj: NSManagedObject) -> Puzzle {
        
        return Puzzle(
            name:              obj.value(forKey: "name")              as! String,
            image:             obj.value(forKey: "image")             as! String,
            photographer:      obj.value(forKey: "photographer")      as! String,
            license:           obj.value(forKey: "license")           as! String,
            photographer_link: obj.value(forKey: "photographer_link") as! String,
            computer_link:     obj.value(forKey: "computer_link")     as! String,
            isSucceeded:       obj.value(forKey: "succeeded")         as! Bool,
            elapsedTime:       obj.value(forKey: "elapsedTime")       as! Double,
            puzzleDate:        obj.value(forKey: "puzzleDate")        as! Date,
            numberOfAttempts:  obj.value(forKey: "numberOfAttempts")  as! Int16
        )
    }
    
    func setPuzzleValues(_ obj: NSManagedObject) {
        
        obj.setValue(self.name,              forKey: "name")
        obj.setValue(self.image,             forKey: "image")
        obj.setValue(self.photographer,      forKey: "photographer")
        obj.setValue(self.license,           forKey: "license")
        obj.setValue(self.photographer_link, forKey: "photographer_link")
        obj.setValue(self.computer_link,     forKey: "computer_link")
        obj.setValue(self.isSucceeded,       forKey: "succeeded")
        obj.setValue(self.elapsedTime,       forKey: "elapsedTime")
        obj.setValue(self.puzzleDate,        forKey: "puzzleDate")
        obj.setValue(self.numberOfAttempts,  forKey: "numberOfAttempts")
    }
}

class DataManager: NSObject {
    
    static let shared = DataManager()
    
    public var currentPuzzle: Puzzle? = nil
    
    public var completedPuzzles: [Puzzle] = []
    
    override init() {
        super.init()
        
        let managedContext = getManagedContext()
        loadPuzzles(managedContext!)
    }
    
    func getManagedContext() -> NSManagedObjectContext? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("cannot get appDelegate")
            return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        return managedContext
    }
    
    func loadPuzzles(_ managedContext: NSManagedObjectContext){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PuzzleStore")
        
        do {
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for data in result {
                let puzzle = Puzzle.fromManagedObject(data)
                completedPuzzles.append(puzzle)
            }
        }
        catch {
            print("Error")
        }
    }
    
    func completePuzzle(_ puzzle: Puzzle) {
        
        completedPuzzles.append(puzzle)
        
        let managedContext = getManagedContext()!
        
        let puzzleEntity = NSEntityDescription.entity(forEntityName: "PuzzleStore", in: managedContext)!
        
        let puzzleStore = NSManagedObject(entity: puzzleEntity, insertInto: managedContext)
        
        puzzle.setPuzzleValues(puzzleStore)
        
        do {
            try managedContext.save()
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

