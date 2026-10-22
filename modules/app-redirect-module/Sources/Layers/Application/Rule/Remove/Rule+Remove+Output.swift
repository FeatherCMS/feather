public import FeatherApplication
public import RedirectModule

extension Rule.Remove {
    public struct Output: DTO {
        public let ids: [String]

        public init(ids: [String]) {
            self.ids = ids
        }
    }
}
