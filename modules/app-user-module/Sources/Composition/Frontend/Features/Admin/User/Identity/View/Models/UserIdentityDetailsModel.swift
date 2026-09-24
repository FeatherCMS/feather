import FeatherAdmin

struct UserIdentityDetailsModel: Sendable {
    let id: String
    let name: String
    let status: String
    let roleIds: [String]
}
