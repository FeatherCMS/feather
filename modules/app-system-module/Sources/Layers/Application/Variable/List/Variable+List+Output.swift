public import FeatherApplication
public import SystemModule

extension Variable.List {
    public struct Output: DTO, Sendable {
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
        public init(items: [Item]) { self.items = items }
    }
}
