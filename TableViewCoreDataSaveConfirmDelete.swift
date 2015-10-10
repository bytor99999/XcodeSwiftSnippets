import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var tableData: [AnyObject] = []
    var deleteRow: NSIndexPath?
    
    var textFieldForAdding: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - TableView DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Hello"
        return cell
    }

    // MARK: - TableView Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let currentObject = tableData[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            deleteRow = indexPath
            let rowToDelete = tableData[indexPath.row]
            confirmDelete(rowToDelete)
        }
    }
    
    // MARK: Add new items
    @IBAction func addButtonPressed(sender: AnyObject) {
        alertPopup()
    }

    func configurationTextField(textField: UITextField) {
        textField.placeholder = "Enter new item"
        self.textFieldForAdding = textField
    }
    
    func saveNewItem() {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let item = NSEntityDescription.insertNewObjectForEntityForName("<#TableName#>", inManagedObjectContext: context) as AnyObject
           //textFieldForAdding.text
        
        do {
            try context.save()
            self.tableData.append(item)
            tableView.reloadData()
        } catch _{
        }
        
    }
    
    func confirmDelete(item: AnyObject) {
        let alert = UIAlertController(title: "Delete To Do Item", message: "Are you sure you want to permanently delete \(item.title)?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: confirmDeleteItem)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func cancelDelete(action: UIAlertAction) {
        tableView.deselectRowAtIndexPath(deleteRow!, animated: true)
        deleteRow = nil
    }
    
    func confirmDeleteItem(action: UIAlertAction) {
        if (deleteRow != nil) {
            tableData.removeAtIndex(deleteRow!.row)
            tableView.deleteRowsAtIndexPaths([deleteRow!], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    func deleteItem(item: AnyObject) {
        
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        context.deleteObject(item as! NSManagedObject)
        do {
            try context.save()
        } catch _{
            print("Not deleted")
        }
    }
    
    func alertPopup() {
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.saveNewItem()
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

}