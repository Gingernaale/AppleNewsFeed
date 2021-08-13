//
//  SavedNewsTableViewController.swift
//  AppleNewsFeed
//
//  Created by Irunya =} on 12/08/2021.
//

import UIKit
import CoreData

class SavedNewsTableViewController: UITableViewController {
    var savedItems = [Items]()
    var context: NSManagedObjectContext?
//    var webURLStringForSource = Int()
    @IBOutlet weak var editButtonTitle: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    func saveData(){
        do{
            try context?.save()
            basicAlert(title: "Saved!", message: "To see your saved article, go to Saved tab bar.")
        }catch{
            print(error.localizedDescription)
        }
        loadData()
    }
    
    func loadData(){
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        do {
            savedItems = try (context?.fetch(request))!
            tableView.reloadData()
        }catch{
            fatalError("Error in retrieving Saved Items")
        }
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        
    }
    
    #warning("change the title of editButtonTitle wouldn't change")
    @IBAction func editButtonTapped(_ sender: Any) {
        
        tableView.isEditing = !tableView.isEditing
        if tableView.isEditing {
            editButtonTitle.title = "Save"
        } else {
            editButtonTitle.title = "Edit"
        }
    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return savedItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedFeedCell", for: indexPath) as? NewsTableViewCell else{
            return UITableViewCell()
        }

        let item = savedItems[indexPath.row]
        cell.newsTitleLabel.text = item.newsTitle
        cell.newsTitleLabel.numberOfLines = 0
        
        if let image = UIImage(data: item.image!){
            cell.newsImageView.image = image
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    #warning("open WbKit")
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //storyBoardId
    }

    #warning("editingStyle == .delete")
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let item = savedItems[indexPath.row]
            self.context?.delete(item)
            
//            #warning "If uncommented line 122 returns cannot find savedItems in Scope"
            deleteAlert(title: "Delete", message: "Delete item?")
//            self.saveData()
//        }
        self.tableView.reloadData()
            
        }
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let row = savedItems.remove(at: fromIndexPath.row)
        savedItems.insert(row, at: to.row)
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
   
    // MARK: - Navigation

// override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    #warning "tableView has already been overriden"
//
//         let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//         guard  let destination = storyboard.instantiateViewController(identifier: "WebViewController") as? WebViewController
//         else {
//             return
//         }
//         navigationController?.pushViewController(destination, animated: true)
//     }
}
