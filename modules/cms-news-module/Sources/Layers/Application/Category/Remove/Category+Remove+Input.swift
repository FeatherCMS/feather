public import FeatherApplication
import NewsDomain
public import NewsModule

extension Category {
    public enum Remove {}
}

extension Category.Remove {
    public struct Input: DTO {
        public let ids: [String]

        public init(ids: [String]) {
            self.ids = ids
        }
    }
}
