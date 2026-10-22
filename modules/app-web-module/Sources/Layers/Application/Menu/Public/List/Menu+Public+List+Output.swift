public import FeatherApplication
public import WebDomain

extension Menu.Public.List {
    public struct Output: DTO {
        public struct Menu: Sendable {
            public struct Item: Sendable {
                public let id: String
                public let label: String
                public let url: String
                public let priority: Int
                public let isBlank: Bool

                public init(
                    id: String,
                    label: String,
                    url: String,
                    priority: Int,
                    isBlank: Bool
                ) {
                    self.id = id
                    self.label = label
                    self.url = url
                    self.priority = priority
                    self.isBlank = isBlank
                }
            }

            public let id: String
            public let key: String
            public let name: String
            public let items: [Item]

            public init(id: String, key: String, name: String, items: [Item]) {
                self.id = id
                self.key = key
                self.name = name
                self.items = items
            }
        }

        public let menus: [Menu]

        public init(menus: [Menu]) {
            self.menus = menus
        }
    }
}
