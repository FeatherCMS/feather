public import ContactModule
public import FeatherApplication

extension Form.Search {
    public struct Output: DTO {
        public struct Item: Sendable {
            public let id: String
            public let key: String
            public let name: String

            package init(id: String, key: String, name: String) {
                self.id = id
                self.key = key
                self.name = name
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
