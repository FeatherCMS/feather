import BlogModule
import FeatherApplication

extension Public.Author.List.Query {
    public struct Output: DTO {
        public let items: [Item]

        public init(items: [Item]) {
            self.items = items
        }
    }
}
