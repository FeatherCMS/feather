import FeatherAdmin

struct AdminEditAccountProfileFormInput: Codable, Sendable {
    let firstName: String?
    let lastName: String?
    let profileImageAssetId: String?
}
