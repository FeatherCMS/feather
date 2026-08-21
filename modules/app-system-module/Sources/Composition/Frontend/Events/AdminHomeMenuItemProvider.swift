import FeatherContracts

public struct AdminHomeMenuItemProvider: Event {
    public typealias Output = [AdminHomeMenuItemDefinition]

    public let menuKey: String

    public init(menuKey: String) {
        self.menuKey = menuKey
    }
}
