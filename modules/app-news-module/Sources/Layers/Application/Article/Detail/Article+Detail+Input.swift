public import FeatherApplication
import NewsDomain
public import NewsModule

extension Article.Detail {
    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
