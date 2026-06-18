import Application
import WebDomain

public struct ReadMenu: Scope {
    public let menu: any MenuQueries

    public init(menu: any MenuQueries) {
        self.menu = menu
    }
}
