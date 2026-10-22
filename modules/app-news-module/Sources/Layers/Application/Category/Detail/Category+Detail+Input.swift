public import FeatherApplication
public import NewsModule
import NewsDomain

extension Category.Detail {
    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
