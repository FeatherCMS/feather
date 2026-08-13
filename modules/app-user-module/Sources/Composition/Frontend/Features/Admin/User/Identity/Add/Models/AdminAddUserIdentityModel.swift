import FeatherAdmin
import Foundation

struct AdminAddUserIdentityModel: Sendable {
    let status: String

    var payload: UserIdentityFormPayloadModel {
        .init(status: status, roleIds: [])
    }
}
