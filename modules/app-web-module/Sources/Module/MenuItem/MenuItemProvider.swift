public import FeatherModuleKit

public struct MenuItemProvider: FeatherModuleKit.Event<[MenuItemDefinition]> {
    public let menuKey: String

    public init(
        menuKey: String
    ) {
        self.menuKey = menuKey
    }
}
