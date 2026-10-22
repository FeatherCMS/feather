public import FeatherApplication

extension Public.Post.List {
    public struct Output: DTO {
        public let items: [Public.Post.Summary.Output]

        public init(items: [Public.Post.Summary.Output]) {
            self.items = items
        }
    }
}
