public import FeatherApplication

extension Public.Author.List {
    public struct Output: DTO {
        public let items: [Public.Author.Summary.Item]

        public init(items: [Public.Author.Summary.Item]) {
            self.items = items
        }
    }
}
