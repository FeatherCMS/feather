import FeatherAdmin
import Foundation

struct UserIdentityDetailsModel: Sendable {
    let id: String
    let status: String
    let roleIds: [String]
}
