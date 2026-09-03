import FeatherAdmin
import Foundation

struct AdminAddUserIdentityModel: Sendable {
    let name: String
    let status: String

    var payload: UserIdentityFormPayloadModel {
        .init(name: name, status: status, roleIds: [])
    }
}
