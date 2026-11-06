public import FeatherApplication
public import SystemModule

extension Variable.Search {
    public struct Output: DTO {
        public struct Item: Sendable {
            public let id: String
            public let key: String
            public let value: String
            public let name: String?
            public let notes: String?

            package init(
                id: String,
                key: String,
                value: String,
                name: String?,
                notes: String?
            ) {
                self.id = id
                self.key = key
                self.value = value
                self.name = name
                self.notes = notes
            }
        }

        public let items: [Item]
        public let total: Int

        public init(items: [Item], total: Int) {
            self.items = items
            self.total = total
        }
    }
}
