import FeatherAdmin
import Foundation

struct UserIdentityFormPayloadModel: Sendable {
    let name: String
    let status: String
    let roleIds: [String]
}
