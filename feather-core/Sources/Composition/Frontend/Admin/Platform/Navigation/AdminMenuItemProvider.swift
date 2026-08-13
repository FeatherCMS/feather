import FeatherContracts

public struct AdminMenuItemProvider: Event {
    public typealias Output = [AdminMenuItemDefinition]

    public let menuKey: String

    public init(menuKey: String) {
        self.menuKey = menuKey
    }
}
