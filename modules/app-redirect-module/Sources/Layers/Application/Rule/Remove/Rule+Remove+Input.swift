public import FeatherApplication
public import RedirectModule

extension RedirectModule.Rule.Remove {
    public struct Input: DTO {
        public let ids: [String]

        public init(ids: [String]) {
            self.ids = ids
        }
    }
}
