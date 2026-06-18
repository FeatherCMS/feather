import Application
import WebDomain

public struct ReadPublicMenu: Scope {
    public let menu: any MenuQueries
    public let menuItem: any MenuItemQueries

    public init(
        menu: any MenuQueries,
        menuItem: any MenuItemQueries
    ) {
        self.menu = menu
        self.menuItem = menuItem
    }
}
