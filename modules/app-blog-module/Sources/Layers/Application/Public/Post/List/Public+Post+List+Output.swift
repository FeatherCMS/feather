public import FeatherApplication

extension Public.Post.List {
    public struct Output: DTO {
        public let items: [Public.Post.Summary.Item]

        public init(items: [Public.Post.Summary.Item]) {
            self.items = items
        }
    }
}
