public import WebModule

extension Menu.Lookup.Query {
    public struct Output: Sendable {
        public let id: String
        public let key: String
        public let name: String

        public init(
            id: String,
            key: String,
            name: String
        ) {
            self.id = id
            self.key = key
            self.name = name
        }
    }
}
