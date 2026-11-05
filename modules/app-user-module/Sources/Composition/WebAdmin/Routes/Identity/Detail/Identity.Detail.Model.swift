import FeatherWebAdmin
import UserAdminAPI
import UserModule

extension Identity.Detail {
    struct Model: Sendable {
        let id: String
        let name: String
        let status: String
        let roleIds: [String]
        let roleNames: [String]
    }
}
