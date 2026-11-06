import BlogModule
public import FeatherApplication

extension Public.Post.List.Query {
    public struct Output: DTO {
        public let items: [Item]

        public init(items: [Item]) {
            self.items = items
        }
    }
}
