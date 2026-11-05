import AccountModule
import FeatherWebShared
import OpenAPIRuntime
import UserAdminAPI
import UserWebAdmin

extension Invitation.Form.Repository.Role {
    struct OpenAPI: Interface {
        let api: UserWebAdmin.API.Client

        func list() async -> [Model] {
            guard
                let response = try? await api.withOpenAPIRepositoryErrorMapping(
                    { client in
                        try await client.userRoleList(
                            query: .init(limit: 100),
                            headers: .init(accept: [.init(contentType: .json)])
                        )
                    }
                ),
                case .ok(let value) = response,
                let roles = try? value.body.json
            else {
                return []
            }

            return roles.map {
                Model(id: $0.id, name: $0.name ?? $0.id)
            }
        }
    }
}
