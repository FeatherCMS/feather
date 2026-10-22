public import FeatherApplication

extension Public.Author.List {
    public struct Output: DTO {
        public let items: [Public.Author.Summary.Output]

        public init(items: [Public.Author.Summary.Output]) {
            self.items = items
        }
    }
}
