import FeatherAdmin
import Foundation
import UserAdminAPI

struct AdminGetUserIdentityModel: Sendable {
    let id: String
    let status: String
    let roleIds: [String]
    let roleNames: [String]

    init(
        details: UserIdentityDetailsModel,
        roleNames: [String] = []
    ) {
        self.id = details.id
        self.status = details.status
        self.roleIds = details.roleIds
        self.roleNames = roleNames
    }
}
