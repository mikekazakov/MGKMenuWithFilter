# MGKMenuWithFilter
A macOS menu that supports items filtration via keyboard input

## About
MGKMenuWithFilter is a class that lets the user show only menu items which have a title with a query string inside. The query string can be changed via keyboard typing while the menu instance is shown. Here's the example:
![](https://kazakov.life/wordpress/wp-content/uploads/2017/05/2017-05-12-10_17_50.gif)


## How to use it
Add the MGKMenuWithFilter source code to the project and programmatically populate a menu instance as usually, but allocate a MGKMenuWithFilter object instead of NSMenu. Here's the code snippet for the example above:
```swift
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
```

## More
MacOS versions supported: [10.8-10.12] are fully supported, 10.7 is partially supported.

Rationale and design notes: https://kazakov.life/2017/05/18/hacking-nsmenu-keyboard-navigation/
