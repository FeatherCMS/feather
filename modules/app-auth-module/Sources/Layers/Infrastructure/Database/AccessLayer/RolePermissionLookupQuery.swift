public import AuthApplication
public import AuthModule
import FeatherDatabase
public import FeatherInfrastructure

extension RolePermission.Lookup.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func permissions(for roleIds: Set<String>) async throws -> Set<
            String
        > {
            guard !roleIds.isEmpty else { return [] }
            var result = Set<String>()
            for roleId in roleIds {
                let permissions = try await context.connection.run(
                    query: #"""
                        SELECT sp.key AS permission_key
                        FROM auth_role_permission AS arp
                        INNER JOIN system_permission AS sp ON sp.id = arp.permission_id
                        WHERE arp.role_id=\#(roleId)
                        ORDER BY sp.key ASC;
                        """#
                ) { rows in
                    try await rows.collect()
                        .map {
                            try $0.decode(
                                column: "permission_key",
                                as: String.self
                            )
                        }
                }
                result.formUnion(permissions)
            }
            return result
        }
    }
}
