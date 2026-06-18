import Application
import WebDomain

public struct ReadMenuItem: Scope {
    public let menuItem: any MenuItemQueries

    public init(menuItem: any MenuItemQueries) {
        self.menuItem = menuItem
    }
}
