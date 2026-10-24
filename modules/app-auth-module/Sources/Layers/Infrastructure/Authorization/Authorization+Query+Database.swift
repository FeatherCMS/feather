public import AuthApplication
public import AuthModule
import FeatherDBAL
public import FeatherInfrastructure
import SystemInfrastructure
import SystemModule
import UserInfrastructure
import UserModule

extension AuthModule.Authorization {
    public struct Database: Roles.Query.Interface, Permissions.Query.Interface {
        private struct Root: DatabaseTableRowDecodable {
            let isRoot: Bool
        }

        private struct RoleID: DatabaseTableRowDecodable {
            let roleId: String
        }

        private struct RoleName: DatabaseTableRowDecodable {
            let name: String?
        }

        private struct PermissionID: DatabaseTableRowDecodable {
            let permissionId: String
        }

        private struct PermissionName: DatabaseTableRowDecodable {
            let name: String?
        }

        private let context: any DatabaseContext

        public init(context: any DatabaseContext) {
            self.context = context
        }

        public func getRolesBy(identityId: String) async throws -> [String] {
            let roleIDs = try await DatabaseAccessLayer<IdentityRole.Table>(
                context: context
            )
            .select(as: RoleID.self) {
                $0.where(\.identityId, equals: identityId)
            }
            .map(\.roleId)

            guard !roleIDs.isEmpty else { return [] }

            return try await DatabaseAccessLayer<Role.Table>(context: context)
                .select(as: RoleName.self) {
                    $0.where(\.id, in: roleIDs)
                        .order(by: [.init(by: \.name)])
                        .columns($0.table.column(\.name))
                }
                .compactMap(\.name)
        }

        public func getPermissionsBy(identityId: String) async throws
            -> [String]
        {
            let identity = try await DatabaseAccessLayer<Identity.Table>(
                context: context
            )
            .selectFirst(
                by: \.id,
                equals: identityId,
                as: Root.self
            )

            guard let identity else { return [] }

            if identity.isRoot {
                return try await permissionNames(where: { query in query })
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
            >(context: context)
            .select(as: PermissionID.self) {
                $0.where(\.roleId, in: roleIDs)
                    .columns($0.table.column(\.permissionId))
            }
            .map(\.permissionId)

            guard !permissionIDs.isEmpty else { return [] }

            return try await permissionNames { query in
                query.where(\.id, in: Array(Set(permissionIDs)))
            }
        }

        private func permissionNames(
            where apply: (DatabaseQuerySelect<Permission.Table>)
                -> DatabaseQuerySelect<Permission.Table>
        ) async throws -> [String] {
            let names = try await DatabaseAccessLayer<Permission.Table>(
                context: context
            )
            .select(as: PermissionName.self) { initial in
                apply(initial)
                    .order(by: [.init(by: \.name)])
                    .columns(initial.table.column(\.name))
            }

            return Array(Set(names.compactMap(\.name))).sorted()
        }
    }
}
