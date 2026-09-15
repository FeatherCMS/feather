import FeatherAdmin
import Foundation

struct UserIdentityEditFormPayloadModel: Sendable {
    let name: String
    let status: String
    let roleIds: [String]
}
