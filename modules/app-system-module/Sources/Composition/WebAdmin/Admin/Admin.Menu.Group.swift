public import FeatherModuleKit

extension Admin.Menu {
    public enum Group {}
    }

    extension Admin.Menu.Group {
    public struct Definition: Sendable {
        public let key: String
        public let groupKey: String
        public let label: String
        public let icon: String
        public let link: String?
        public let permission: String?
        public let priority: Int

        public init(
            key: String,
            groupKey: String,
            label: String,
            icon: String,
            link: String? = nil,
            permission: String? = nil,
            priority: Int = 0
        ) {
            self.key = key
            self.groupKey = groupKey
            self.label = label
            self.icon = icon
            self.link = link
            self.permission = permission
            self.priority = priority
        }
    }

    public struct Provider: FeatherModuleKit.Event<[Definition]> {
        public init() {}
    }
}
