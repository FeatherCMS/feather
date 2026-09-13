import FeatherAdmin
import Foundation

struct UserIdentityAddFormPayloadModel: Sendable {
    let name: String
    let status: String
    let roleIds: [String]
}
