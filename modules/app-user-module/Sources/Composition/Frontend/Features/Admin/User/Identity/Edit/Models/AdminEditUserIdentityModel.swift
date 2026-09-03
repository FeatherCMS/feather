import FeatherAdmin
import Foundation

struct AdminEditUserIdentityModel: Sendable {
    let id: String
    let name: String
    let status: String
    let roleIds: [String]

    var payload: UserIdentityFormPayloadModel {
        .init(name: name, status: status, roleIds: roleIds)
    }
}
