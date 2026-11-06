public import FeatherApplication
public import WebModule

extension MenuItem.Remove {
    public struct Output: DTO {
        public let ids: [String]

        public init(ids: [String]) {
            self.ids = ids
        }
    }
}
