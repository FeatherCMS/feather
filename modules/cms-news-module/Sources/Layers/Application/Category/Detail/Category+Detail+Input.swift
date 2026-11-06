public import FeatherApplication
import NewsDomain
public import NewsModule

extension Category.Detail {
    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
