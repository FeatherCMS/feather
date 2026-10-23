public import FeatherApplication

extension Public.Category.List {
    public struct Output: DTO {
        public let items: [Public.Category.Summary.Item]

        public init(items: [Public.Category.Summary.Item]) {
            self.items = items
        }
    }
}
