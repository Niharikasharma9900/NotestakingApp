

import UIKit
import CoreData

class AddEditVC : UIViewController, NSFetchedResultsControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var imageFrom: UIImageView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //(UIApplication.sharedApplication.delegate as! AppDelegate).managedObjectContext
    
    var nItem: Notes? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        if nItem != nil
        {
            descTextView.text = nItem?.desc
            if(nItem?.image != nil){
                imageFrom.image = UIImage(data: (nItem?.image)! as Data)
            }
//            entryNote.text = nItem?.note
//            entryQty.text  = nItem?.quantity
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    @IBAction func cancelTap(_ sender: Any) {
        discmissVC()
    }
    
    
    @IBAction func saveTap(_ sender: Any) {
        if nItem != nil
        {
            editItem()
        }
        else
        {
            newItem()
        }
        
        discmissVC()
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        
        present(pickerController,animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        imageFrom.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func discmissVC()
    {
        navigationController?.popViewController(animated: true)
    }
    
    func newItem()
    {
        let context = self.context
        let ent = NSEntityDescription.entity(forEntityName: "Notes", in: context)
        
        let ListItem = Notes(entity: ent!, insertInto: context)
        
        ListItem.desc = descTextView.text
        if(imageFrom.image != nil){
            ListItem.image = UIImagePNGRepresentation(imageFrom.image!) as Data?
        }
        //ListItem.quantity = entryQty.text!
        
        do {
            try context.save()
        }
        catch {
            let error = error as NSError
            print(error.description)
        }
    }
    
    func editItem()
    {
        nItem!.desc = descTextView.text
        nItem!.image = UIImagePNGRepresentation(imageFrom.image!) as Data?
        
        //nItem!.quantity = entryQty.text!
        
        do {
            try context.save()
        }
        catch {
            let error=error as NSError
            print(error.description)
            
        }
    }
    
}

