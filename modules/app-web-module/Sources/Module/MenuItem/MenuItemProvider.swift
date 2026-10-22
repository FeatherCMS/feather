public import FeatherModuleKit

public struct MenuItemProvider: FeatherModuleKit.Event {
    public typealias Output = [MenuItemDefinition]

    public let menuKey: String

    public init(
        menuKey: String
    ) {
        self.menuKey = menuKey
    }
}
