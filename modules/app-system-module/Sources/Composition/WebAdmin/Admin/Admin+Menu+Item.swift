public import FeatherModuleKit

extension Admin.Menu {
    public enum Item {}
    }

    extension Admin.Menu.Item {
    public struct Definition: Sendable {
        public let menuKey: String
        public let label: String
        public let icon: String
        public let link: String
        public let permission: String?
        public let priority: Int

        public init(
            menuKey: String,
            label: String,
            icon: String,
            link: String,
            permission: String? = nil,
            priority: Int = 0
        ) {
            self.menuKey = menuKey
            self.label = label
            self.icon = icon
            self.link = link
            self.permission = permission
            self.priority = priority
        }
    }

    public struct Provider: FeatherModuleKit.Event {
        public typealias Output = [Definition]

        public let menuKey: String

        public init(menuKey: String) {
            self.menuKey = menuKey
        }
    }
}
