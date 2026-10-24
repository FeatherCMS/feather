public import AccountModule
public import FeatherApplication

extension Profile.Detail {
    public struct Input: DTO {
        public let userId: String?

        public init(userId: String? = nil) {
            self.userId = userId
        }
    }
}
