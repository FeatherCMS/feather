import Application
import WebDomain

public struct WriteMenuItem: Scope {
    public let menuItem: any MenuItemRepository

    public init(menuItem: any MenuItemRepository) {
        self.menuItem = menuItem
    }
}
