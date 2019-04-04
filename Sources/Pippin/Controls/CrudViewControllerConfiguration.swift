//
//  CrudViewControllerConfiguration.swift
//  Pippin
//
//  Created by Andrew McKnight on 8/12/18.
//  Copyright © 2018 Two Ring Software. All rights reserved.
//

import CoreData
import UIKit

/// The set of modes in which a `CrudViewController` may be used. Different controls may be available depending on the mode being used.
///
/// - editor: A `CrudViewController` with readwrite access to the underlying model.
/// - picker: A `CrudViewController` with readonly access to the underlying model.
public enum CrudViewControllerMode {
    /// A `CrudViewController` with readwrite access to the underlying model.
    case editor
    
    /// A `CrudViewController` with readonly access to the underlying model.
    case picker
}

/// A protocol providing callbacks providing different parts of the UI to configure styles and themes.
@available(iOS 11.0, *) @objc public protocol CrudViewControllerThemeDelegate {
    /// Provides a `UITableViewCell` instance that will be used for the add item cell in a `CrudViewController` with a `CrudViewControllerMode` of `editor`.
    ///
    /// - Parameters:
    ///   - crudViewController: The instance of `CrudViewController` about to present its add item cell.
    ///   - addItemCell: The instance of the cell to configure.
    @objc optional func crudViewController(crudViewController: CrudViewController, themeAddItemCell addItemCell: TextAndAccessoryCell)
    
    /// Sylize the search controls. Will only be called if `crudViewControllerShouldEnableSearch` returns `true`.
    ///
    /// - Parameters:
    ///   - crudViewController: The `CrudViewController` containing the search controls to style.
    ///   - searchField: The text input for search.
    ///   - cancelButton: The cancel button to end search.
    @objc optional func crudViewController(crudViewController: CrudViewController, theme searchField: UITextField, cancelButton: UIButton)
    
    /// Ask the theme delegate if the search controls should be given blur backgrounds and vibrancy effects. Defaults to `false`.
    ///
    /// - Parameter crudViewController: The `CrudViewController` containing the search controls.
    /// - Returns: `true` if the search field and cancel button should be blurred, `false` otherwise.
    @objc optional func crudViewControllerShouldBlurSearchControls(crudViewController: CrudViewController) -> Bool
    
    /// - Parameter crudViewController: The `CrudViewController` containing the search controls.
    /// - Returns: An instance of a view to show instead of the empty table.
    @objc optional func crudViewControllerEmptyStateView(crudViewController: CrudViewController) -> UIView
    
    /// Provide a set of custom insets for the table view, to help with alignment/layout with other elements that may be onscreen.
    ///
    /// - Parameter crudViewController: The `CrudViewController` displaying the `UITableView` whose content should be inset.
    /// - Returns: A `UIEdgeInsets` struct defining insets for the `CrudViewController` instance's `UITableView`.
    @objc optional func crudViewControllerTableViewContentInsets(crudViewController: CrudViewController) -> UIEdgeInsets
}

/// A protocol to notify delegates about different CRUD operations being performed by the user. Only called by instances of `CrudViewController` with a `CrudViewControllerMode` of `editor`.
@available(iOS 11.0, *) @objc public protocol CrudViewControllerCRUDDelegate {
    /// Called when the user has tapped the add item cell in an instance of `CrudViewController` with a `CrudViewControllerMode` of `editor`.
    ///
    /// - Parameter crudViewController: The instance of `CrudViewController` handling the add item cell selection.
    @objc optional func crudViewControllerWantsToCreateObject(crudViewController: CrudViewController)
    
    /// Called when a user selects an entity cell in an instance of `CrudViewController`. With a `CrudViewControllerMode` of `editor` this usually means transitioning to a detail view of the underlying object, and `picker` means just that the user made their selection.
    ///
    /// - Parameters:
    ///   - crudViewController: The instance of `CrudViewController` handling the entity cell selection.
    ///   - object: The underlying object represented by the selected cell.
    @objc optional func crudViewController(crudViewController: CrudViewController, wantsToRead object: NSFetchRequestResult)
    
    /// Called when a user has elected to update an underlying object represented by a cell in an instance of `CrudViewController` with a `CrudViewControllerMode` of `editor`.
    ///
    /// - Parameters:
    ///   - crudViewController: The instance of `CrudViewController` handling the entity update.
    ///   - object: The underlying object represented by the selected cell.
    @objc optional func crudViewController(crudViewController: CrudViewController, wantsToUpdate object: NSFetchRequestResult)
    
    /// Called when a user has elected to delete an entity an instance of `CrudViewController` with a `CrudViewControllerMode` of `editor`.
    ///
    /// - Parameters:
    ///   - crudViewController: The instance of `CrudViewController` handling the entity deletion.
    ///   - object: The underlying object being targeted for deletion.
    @objc optional func crudViewController(crudViewController: CrudViewController, wantsToDelete object: NSFetchRequestResult)
}

/// A protocol to configure the `UITableView` managed by the `CrudViewController`. At a minimum, requires an implementation to configure a cell to display for a given object.
@available(iOS 11.0, *) @objc public protocol CrudViewControllerUITableViewDelegate {
    /// Configure a cell to represent a provided object.
    ///
    /// - Parameters:
    ///   - crudViewController: The `CrudViewController` managing the entity and table view into which the cell will be inserted.
    ///   - cell: The `UITableViewCell` instance that will represent the provided object.
    ///   - object: The object to be represented in the cell.
    ///   - lastObject: If `true`, the cell will appear at the end of the table view, in case different styling is desired.
    func crudViewController(crudViewController: CrudViewController, configure cell: UITableViewCell, forObject object: NSFetchRequestResult, lastObject: Bool)
    
    /// Provide a custom `UITableView` subclass to use for entity cells. The default value used is `UITableViewCell`.
    ///
    /// - Parameter crudViewController: The `CrudViewController` managing the cells.
    /// - Returns: The class of the custom `UITableView` to be registered.
    @objc optional func crudViewControllerCellClassToRegister(crudViewController: CrudViewController) -> AnyClass
    
    /// Control whether an object may have `UITableViewRowAction`s performed on it. If the `CrudViewControllerMode` is `editor`, then the default value is `true`.
    ///
    /// - Note: If `CrudViewControllerMode` is `picker` then this function is not called.
    ///
    /// - Parameters:
    ///   - crudViewController: The `CrudViewController` managing the entity.
    ///   - object: The object that may or may not receive actions.
    /// - Returns: `true` if the `UITableView` should display `UITableViewRowAction`s for the provided object, `false` if no `UITableViewRowAction`s should be shown.
    @objc optional func crudViewController(crudViewController: CrudViewController, canEdit object: NSFetchRequestResult) -> Bool
    
    /// Provide an array of other edit actions to show alongside the standard “Edit” and “Delete” actions automatically provided by instances of `CrudViewController` with a `CrudViewControllerMode` of `editor`.
    /// - Note: This is not called for the add item cell and no actions are provided for it at all.
    /// - Note: If `CrudViewControllerMode` is `picker` then this function is not called.
    /// - Note: If `crudViewController(crudViewController:canEdit:)` returns false then this function is not called.
    /// - Note: If an array is returned for `crudViewController(crudViewController:otherEditActionsFor:)`, this function is not called.
    /// - Parameters:
    ///   - crudViewController: The `CrudViewController` managing the cells receiving additional edit actions.
    ///   - indexPath: The `IndexPath` for the cell that should receive a given set of additional actions.
    /// - Returns: The additional actions that should be shown alongside “Edit” and “Delete.”
    @objc optional func crudViewController(crudViewController: CrudViewController, otherEditActionsFor indexPath: IndexPath) -> [UITableViewRowAction]

    /// - Note: This is not called for the add item cell and no actions are provided for it at all.
    /// - Note: If `CrudViewControllerMode` is `picker` then this function is not called.
    /// - Note: If `crudViewController(crudViewController:canEdit:)` returns false then this function is not called.
    /// - Parameters:
    ///   - crudViewController: The `CrudViewController` managing the cells receiving additional edit actions.
    ///   - indexPath: The `IndexPath` for the cell that should receive a given set of additional actions.
    /// - Returns: All the edit actions to show for the cell at the given `IndexPath`
    @objc optional func crudViewController(crudViewController: CrudViewController, editActionsFor indexPath: IndexPath) -> [UITableViewRowAction]
    
    /// Control whether the `UITableView` should include an add item cell. Default value is `true` when `CrudViewControllerMode` is `editor`.
    ///
    /// - Note: If `CrudViewControllerMode` is `picker` then this function is not called.
    ///
    /// - Parameter crudViewController: The `CrudViewController` managing the `UITableView` that may display an add item cell.
    /// - Returns: `true` if an add item cell should be shown, `false` otherwise.
    @objc optional func crudViewControllerShouldShowAddItemRow(crudViewController: CrudViewController) -> Bool
}

/// A protocol declaring functions called for interacting with search over the entities managed by the `CrudViewController`.
@available(iOS 11.0, *) public protocol CrudViewControllerSearchDelegate {
    /// Decide whether or not the search controls should be accessible to users. Defaults to `false`.
    ///
    /// - Parameter crudViewController: The `CrudViewController` managing the search controls.
    /// - Returns: `true` if the `CrudViewController` should display search controls, `false` otherwise.
    func crudViewControllerShouldEnableSearch(crudViewController: CrudViewController) -> Bool
    
    /// Given a search term, provide an `NSPredicate` to apply to the fetch request used by the `CrudViewController` to obtain the list of elements to be displayed in the `UITableView`. Defaults to `NSPredicate(value: false)`.
    ///
    /// - Note: Not called if `crudViewControllerShouldEnableSearch(crudViewController:) -> Bool` returns `false`.
    ///
    /// - Parameters:
    ///   - crudViewController: The `CrudViewController` managing the search controls.
    ///   - string: The search term entered by the user.
    /// - Returns: An `NSPredicate` that uses the search term to appropriately query the underlying data model.
    func crudViewController(crudViewController: CrudViewController, predicateForSearchString string: String) -> NSPredicate
}

/// A `struct` containing references to delegates for the various protocols, the underlying data model, `CrudViewControllerMode` and name. At a minimum, you must provide a way to display data via data model references and `CrudViewControllerUITableViewDelegate.crudViewController(crudViewController:configure:forObject:lastObject:)`.
@available(iOS 11.0, *) public struct CrudViewControllerConfiguration {
    public init(tableViewDelegate: CrudViewControllerUITableViewDelegate, crudDelegate: CrudViewControllerCRUDDelegate, searchDelegate: CrudViewControllerSearchDelegate?, themeDelegate: CrudViewControllerThemeDelegate?, fetchRequest: NSFetchRequest<NSFetchRequestResult>, context: NSManagedObjectContext, mode: CrudViewControllerMode, name: String? = nil) {
        self.tableViewDelegate = tableViewDelegate
        self.crudDelegate = crudDelegate
        self.searchDelegate = searchDelegate
        self.themeDelegate = themeDelegate
        self.fetchRequest = fetchRequest
        self.context = context
        self.mode = mode
        self.name = name
    }
    
    public let tableViewDelegate: CrudViewControllerUITableViewDelegate
    public let crudDelegate: CrudViewControllerCRUDDelegate
    public let searchDelegate: CrudViewControllerSearchDelegate?
    public let themeDelegate: CrudViewControllerThemeDelegate?
    
    public let fetchRequest: NSFetchRequest<NSFetchRequestResult>
    public let context: NSManagedObjectContext
    
    public let mode: CrudViewControllerMode
    
    public let name: String?
}
