public import FeatherApplication
public import NewsModule

extension Article.Remove {
    public struct Output: DTO {
        public let ids: [String]

        public init(ids: [String]) {
            self.ids = ids
        }
    }
}
