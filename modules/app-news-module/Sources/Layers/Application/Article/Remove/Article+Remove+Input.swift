public import FeatherApplication
import NewsDomain
public import NewsModule

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
