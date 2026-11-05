public import FeatherApplication
public import UserModule

extension Identity.Detail {
    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
