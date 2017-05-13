
import UIKit
import CoreData

class MainTableVC: UITableViewController,NSFetchedResultsControllerDelegate {
    
    var context :NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var frc : NSFetchedResultsController<Notes>? = NSFetchedResultsController()
    
    
    func getFetchResultsController() -> NSFetchedResultsController<Notes>?
    {
        frc = NSFetchedResultsController(fetchRequest: listFetchRequest() as! NSFetchRequest<Notes>, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        return frc
    }
    
    func listFetchRequest() -> NSFetchRequest<NSFetchRequestResult>
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        let sortDescriptor = NSSortDescriptor(key: "desc", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 60
        
        frc = getFetchResultsController()
        frc?.delegate = self
        do{
            try frc?.performFetch()
        }
        catch {
            let error=error as NSError
            print(error.description)
        }


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    //to ave fresh data if new data is added
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        let numberOfSections = frc?.sections?.count
        return numberOfSections!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let numberOfRwosInSection = frc?.sections?[section].numberOfObjects
        
        return numberOfRwosInSection!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let list = (frc?.object(at: indexPath))! as Notes
        
        cell.textLabel?.text = list.desc
        if(list.image != nil){
            cell.imageView?.image = UIImage(data: (list.image)! as Data)
        }
        //let note = list.note!
        //let qty  = list.quantity
        let date = Date()
        let formatter = DateFormatter()
        
        
        formatter.dateFormat = "dd.MM.yyyy"
        
        let result = formatter.string(from: date)
    
        
        cell.detailTextLabel?.text = result
        
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
     //Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let managedObject : NSManagedObject = (frc?.object(at: indexPath))!//frc?.object(at: <#T##IndexPath#>))! as NSManagedObject
        context.delete(managedObject)
        
        do{
            try  context.save()
            
        }
        catch {
            let error=error as NSError
            print(error.description)
            
        }

    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "edit"{
            
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath( for: cell)
            
            let newController: AddEditVC = segue.destination as! AddEditVC
            
            let nItem : Notes = (frc?.object(at: indexPath!))! as Notes
            newController.nItem = nItem
            
        }
    }

}
