public import ContactDomain
public import ContactModule
public import FeatherApplication

extension FormField.Search {
    public struct Output: DTO {
        public struct Item: Sendable {
            public let id: String
            public let key: String
            public let type: FormField.Model.ItemType
            public let label: String
            public let isRequired: Bool

            public init(
                id: String,
                key: String,
                type: FormField.Model.ItemType,
                label: String,
                isRequired: Bool
            ) {
                self.id = id
                self.key = key
                self.type = type
                self.label = label
                self.isRequired = isRequired
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
