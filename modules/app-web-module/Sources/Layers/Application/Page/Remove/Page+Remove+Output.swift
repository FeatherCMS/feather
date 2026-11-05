public import FeatherApplication
public import WebModule

extension Page.Remove {
    public struct Output: DTO {
        public let ids: [String]

        public init(ids: [String]) {
            self.ids = ids
        }
    }
}
