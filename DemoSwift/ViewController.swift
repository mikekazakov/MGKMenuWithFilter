import Cocoa
import Quartz

class ViewController: NSViewController {

    @IBOutlet var pushMeButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func showPopUpMenu(_ sender: Any) {
        let folder = NSURL.fileURL(withPath: "/Library/Desktop Pictures")

        let all_files = try! FileManager.default.contentsOfDirectory(at:folder,
                                                               includingPropertiesForKeys:nil,
                                                               options:.skipsSubdirectoryDescendants)
        
        let jpg_files = all_files.filter() { $0.absoluteString.hasSuffix(".jpg") }
        

        let menu = MGKMenuWithFilter.init(title: "Pictures")!
        
        for picture in jpg_files {
            let item = NSMenuItem()
            
            item.title = picture.lastPathComponent
            
            item.action = #selector(showPicture(_:))
            item.target = self

            let size = NSMakeSize(32, 32)
            let preview = QLThumbnailImageCreate(nil, picture as CFURL!, size, nil as CFDictionary!)
            if preview != nil  {
                item.image = NSImage.init(cgImage:preview!.takeUnretainedValue(), size: size)
                preview!.release()
            }
            
            item.representedObject = picture

            menu.addItem(item)
        }
    
        menu.popUp(positioning: nil,
                   at: NSMakePoint(0, pushMeButton.bounds.size.height),
                   in: pushMeButton)
    
    }
    
    @IBAction func showPicture(_ sender: Any) {
        NSWorkspace.shared().open((sender as! NSMenuItem).representedObject as! URL)
    }

}

