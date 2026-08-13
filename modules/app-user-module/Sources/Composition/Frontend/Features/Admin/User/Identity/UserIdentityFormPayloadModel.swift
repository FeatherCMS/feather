import FeatherAdmin
import Foundation

struct UserIdentityFormPayloadModel: Sendable {
    let status: String
    let roleIds: [String]
}
