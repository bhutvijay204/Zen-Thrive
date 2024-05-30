//
//  QuizHistoryVC.swift
//  Zen Thrive
//
//  Created by Hitesh Mac on 18/05/24.
//

import UIKit

struct HistoryRecord {
    let score: String
    let Round : Int
}

class QuizHistoryVC: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var history: [HistoryRecord] = [] {
        didSet {
            tableView.reloadData()
        }
    }
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        loadHistory()
    }
    
    
    @IBAction func BackBtnTApped(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    func loadHistory() {
        if let historyArray = UserDefaults.standard.array(forKey: "history") as? [[String: Any]] {
            for record in historyArray {
                if let score = record["Scores"] as? String,
                   let Round = record["Rounds"] as? Int
                  {
                    history.append(HistoryRecord(score: score, Round: Round))
                }
            }
        }
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        let record = history[indexPath.row]
        
        // Apply Avenir Next font
        cell.LablCell.text = record.score
        cell.DateCell.text = " Your Visible Images Are \(record.Round)"

        return cell
    }
    
    @IBAction func toggleEditingMode(_ sender: UIBarButtonItem) {
        // Toggles editing mode for the table view
        tableView.isEditing = !tableView.isEditing
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the record from the history array
            history.remove(at: indexPath.row)
            
            // Delete the corresponding record from UserDefaults
            var historyArray = UserDefaults.standard.array(forKey: "history") as? [[String: Any]] ?? []
            historyArray.remove(at: indexPath.row)
            UserDefaults.standard.set(historyArray, forKey: "history")
            
            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
