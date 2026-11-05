public import AuthApplication
public import AuthModule
import FeatherDBAL
public import FeatherInfrastructure
import SystemInfrastructure
import SystemModule
import UserInfrastructure
import UserModule

extension AuthModule.Authorization.Permissions.Query {
    public struct Database: Interface {
        private struct Root: DatabaseTableRowDecodable {
            let isRoot: Bool

            enum CodingKeys: String, CodingKey {
                case isRoot = "is_root"
            }
        }

        private struct RoleID: DatabaseTableRowDecodable {
            let roleId: String

            enum CodingKeys: String, CodingKey {
                case roleId = "role_id"
            }
        }

        private struct PermissionID: DatabaseTableRowDecodable {
            let permissionId: String

            enum CodingKeys: String, CodingKey {
                case permissionId = "permission_id"
            }
        }

        private struct PermissionKeyValue: DatabaseTableRowDecodable {
            let key: String

            enum CodingKeys: String, CodingKey {
                case key = "key"
            }
        }

        private let context: any DatabaseContext

        public init(context: any DatabaseContext) {
            self.context = context
        }

        public func getPermissionsBy(identityId: String) async throws
            -> [String]
        {
            let identity = try await DatabaseAccessLayer<Identity.Table>(
                context: context
            )
            .selectFirst(by: \.id, equals: identityId, as: Root.self)
            guard let identity else { return [] }
            if identity.isRoot {
                return try await permissionKeys(where: { query in query })
            }
            let roleIDs = try await DatabaseAccessLayer<IdentityRole.Table>(
                context: context
            )
            .select(as: RoleID.self) {
                $0.where(\.identityId, equals: identityId)
            }
            .map(\.roleId)
            guard !roleIDs.isEmpty else { return [] }
            let permissionIDs = try await DatabaseAccessLayer<
                RolePermission.Table
            >(
                context: context
            )
            .select(as: PermissionID.self) {
                $0.where(\.roleId, in: roleIDs)
                    .columns($0.table.column(\.permissionId))
            }
            .map(\.permissionId)
            guard !permissionIDs.isEmpty else { return [] }
            return try await permissionKeys { query in
                query.where(\.id, in: Array(Set(permissionIDs)))
            }
        }

        private func permissionKeys(
            where apply: (DatabaseQuerySelect<Permission.Table>)
                -> DatabaseQuerySelect<Permission.Table>
        ) async throws -> [String] {
            let keys = try await DatabaseAccessLayer<Permission.Table>(
                context: context
            )
            .select(as: PermissionKeyValue.self) { initial in
                apply(initial)
                    .order(by: [.init(by: \.key)])
                    .columns(initial.table.column(\.key))
            }
            return Array(Set(keys.map(\.key))).sorted()
        }
    }
}
