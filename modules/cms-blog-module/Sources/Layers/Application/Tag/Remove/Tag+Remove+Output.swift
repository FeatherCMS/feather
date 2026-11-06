public import BlogModule
public import FeatherApplication

extension Tag.Remove {
    public struct Output: DTO {
        public let ids: [String]

        package init(ids: [String]) {
            self.ids = ids
        }
    }
}
