import FeatherContracts

public struct WebMenuItemProvider: Event {
    public typealias Output = [WebMenuItemDefinition]

    public let menuKey: String

    public init(
        menuKey: String
    ) {
        self.menuKey = menuKey
    }
}
