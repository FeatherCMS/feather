import AuthAdminAPI
import AuthModule

extension MagicLink.List {
    struct Result: Sendable {
        let items: [Components.Schemas.AuthMagicLinkQueryItemSchema]
        let emailByAuthEmailId: [String: String]
        let total: Int
        let page: Int
        let size: Int
    }
}
