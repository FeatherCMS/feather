public import FeatherApplication
public import NewsDomain

extension Article {
    public enum Remove {}
}

extension Article.Remove {
    public struct Input: DTO {
        public let ids: [String]

        public init(ids: [String]) {
            self.ids = ids
        }
    }
}
