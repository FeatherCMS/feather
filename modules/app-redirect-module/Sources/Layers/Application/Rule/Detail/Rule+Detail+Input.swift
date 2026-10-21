public import FeatherApplication
public import RedirectModule

extension RedirectModule.Rule.Detail {
    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
