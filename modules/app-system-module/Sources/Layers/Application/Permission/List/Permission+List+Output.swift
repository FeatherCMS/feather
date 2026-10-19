public import SystemModule
public import FeatherApplication

extension Permission.List {
    public struct Output: FeatherApplication.DTO {
        public struct Item: Sendable {
            public let id: String
            public let key: String
            public let name: String?
            public let notes: String?

            package init(id: String, key: String, name: String?, notes: String?)
            {
                self.id = id
                self.key = key
                self.name = name
                self.notes = notes
            }
        }

        public let items: [Item]

        public init(items: [Item]) {
            self.items = items
        }
    }
}
