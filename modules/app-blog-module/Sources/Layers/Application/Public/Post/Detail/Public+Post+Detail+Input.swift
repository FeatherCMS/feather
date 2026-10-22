public import BlogModule
public import FeatherApplication

extension Public.Post.Detail {
    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
