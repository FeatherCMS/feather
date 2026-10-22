public import FeatherModuleKit

public struct WebMenuItemProvider: FeatherModuleKit.Event {
    public typealias Output = [WebMenuItemDefinition]

    public let menuKey: String

    public init(
        menuKey: String
    ) {
        self.menuKey = menuKey
    }
}
