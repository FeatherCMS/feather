public import AccountModule
public import FeatherApplication

extension Profile.Edit {
    public struct Input: DTO {
        public let firstName: String?
        public let lastName: String?
        public let profileImageAssetId: String?
        public let userId: String?

        public init(
            firstName: String?,
            lastName: String?,
            profileImageAssetId: String?,
            userId: String? = nil
        ) {
            self.firstName = firstName
            self.lastName = lastName
            self.profileImageAssetId = profileImageAssetId
            self.userId = userId
        }
    }
}
