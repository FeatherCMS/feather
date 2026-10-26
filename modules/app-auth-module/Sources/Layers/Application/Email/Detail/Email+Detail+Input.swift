public import AuthModule
public import FeatherApplication

extension Email.Detail {
    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
