public import BlogModule
public import FeatherApplication

extension Tag.Remove {
    public struct Input: DTO {
        public let ids: [String]

        public init(ids: [String]) {
            self.ids = ids
        }
    }
}
