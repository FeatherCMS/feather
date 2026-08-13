import FeatherAdmin
import Foundation

struct AdminEditUserIdentityModel: Sendable {
    let id: String
    let status: String
    let roleIds: [String]

    var payload: UserIdentityFormPayloadModel {
        .init(status: status, roleIds: roleIds)
    }
}
