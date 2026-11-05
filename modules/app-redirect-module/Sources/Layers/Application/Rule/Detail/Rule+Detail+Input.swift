public import FeatherApplication
public import RedirectModule

extension Rule.Detail {
    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
