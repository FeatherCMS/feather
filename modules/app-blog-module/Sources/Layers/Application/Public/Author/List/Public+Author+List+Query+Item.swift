import BlogModule

extension Public.Author.List.Query {
    public struct Item: Sendable {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
