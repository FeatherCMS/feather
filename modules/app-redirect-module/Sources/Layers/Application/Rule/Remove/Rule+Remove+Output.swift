import FeatherApplication
import RedirectModule

extension RedirectModule.Rule.Remove {
    public struct Output: DTO {
        public let ids: [String]

        public init(ids: [String]) {
            self.ids = ids
        }
    }
}
