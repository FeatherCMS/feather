import FeatherApplication
import FeatherContracts
import Foundation

public struct AccountProfileDetail: DTO {
    public let userId: String
    public let firstName: String?
    public let lastName: String?
    public let profileImageAssetId: String?
    public let createdAt: Date
    public let updatedAt: Date

    public init(
        userId: String,
        firstName: String?,
        lastName: String?,
        profileImageAssetId: String?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.profileImageAssetId = profileImageAssetId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
