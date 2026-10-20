import FeatherWebAdmin
import UserAdminAPI
import UserModule

extension Identity.Detail {
    struct ViewModel: Sendable {
        let id: String
        let name: String
        let status: String
        let roleIds: [String]
        let roleNames: [String]

        init(
            details: Identity.Detail.RepositoryModel,
            roleNames: [String] = []
        ) {
            self.id = details.id
            self.name = details.name
            self.status = details.status
            self.roleIds = details.roleIds
            self.roleNames = roleNames
        }
    }
}
