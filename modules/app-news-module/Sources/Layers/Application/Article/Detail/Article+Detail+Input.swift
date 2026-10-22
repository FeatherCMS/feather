public import FeatherApplication
public import NewsDomain

extension Article.Detail {
    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
