public import AccountModule
public import FeatherApplication

extension Settings.Detail {
    public struct Input: DTO {
        public let userId: String?

        public init(userId: String? = nil) {
            self.userId = userId
        }
    }
}
