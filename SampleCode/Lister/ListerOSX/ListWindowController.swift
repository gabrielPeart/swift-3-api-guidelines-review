/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The `ListWindowController` class is a window controller that displays a single list document. It also handles interaction with the "share" button and the "plus" button (for creating a new item).
*/

import Cocoa
import ListerKit

class ListWindowController: NSWindowController, SegueHandlerType {
    // MARK: SegueHandlerType
    
    enum SegueIdentifier: String {
        case ShowAddItem
    }
    
    // MARK: IBOutlets

    @IBOutlet weak var shareButton: NSButton!
    
    // MARK: View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        let action = Int(NSEventMask.LeftMouseDown.rawValue)
        shareButton.sendActionOn(action)
    }
    
    // MARK: Keyboard Shortcuts
    
    /// Allow the user to create a new list item with a keyboard shortcut (command-N).
    @IBAction func showAddItemViewController(sender: AnyObject?) {
        performSegueWith(.ShowAddItem, sender: sender)
    }

    // MARK: Overrides
    
    override var document: AnyObject? {
        didSet {
            let listViewController = window!.contentViewController as! ListViewController
            
            listViewController.document = document as? ListDocument
        }
    }
    
    override func prepareFor(segue: NSStoryboardSegue, sender: AnyObject?) {
        let segueIdentifier = segueIdentifierFor(segue)
        
        switch segueIdentifier {
            case .ShowAddItem:
                let listViewController = window!.contentViewController as! ListViewController
                
                let addItemViewController = segue.destinationController as! AddItemViewController
                
                addItemViewController.delegate = listViewController
        }
    }
    
    // MARK: IBActions

    @IBAction func shareDocument(sender: NSButton) {
        if let listDocument = document as? ListDocument {
            let listContents = ListFormatting.stringFrom(listDocument.listPresenter!.presentedListItems)
            
            let sharingServicePicker = NSSharingServicePicker(items: [listContents])
            
            let preferredEdge =  NSRectEdge(rawValue: UInt(CGRectEdge.MinYEdge.rawValue))!
            sharingServicePicker.showRelativeTo(NSZeroRect, of: sender, preferredEdge: preferredEdge)
        }
    }
}
