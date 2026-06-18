import Application
import WebDomain

public struct WriteMenu: Scope {
    public let menu: any MenuRepository

    public init(menu: any MenuRepository) {
        self.menu = menu
    }
}
