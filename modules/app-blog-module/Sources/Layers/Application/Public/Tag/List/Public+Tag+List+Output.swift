public import FeatherApplication

extension Public.Tag.List {
    public struct Output: DTO {
        public let items: [Public.Tag.Summary.Item]

        public init(items: [Public.Tag.Summary.Item]) {
            self.items = items
        }
    }
}
