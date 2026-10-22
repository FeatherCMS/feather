public import FeatherApplication
public import NewsDomain

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
