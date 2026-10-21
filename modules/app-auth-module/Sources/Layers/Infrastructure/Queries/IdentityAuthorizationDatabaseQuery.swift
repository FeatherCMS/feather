public import AuthApplication
public import FeatherDatabase
public import UserModule

extension Identity.Authorization.Query {
    public struct Database: Interface {
        public let connection: any DatabaseConnection

        public init(connection: any DatabaseConnection) {
            self.connection = connection
        }

        public func getRolesBy(identityId: String) async throws -> [String] {
            try await connection.run(
                query: #"""
                    SELECT ur.name
                    FROM user_identity_role uir
                    INNER JOIN user_role ur ON ur.id = uir.role_id
                    WHERE uir.identity_id = \#(identityId)
                    ORDER BY ur.name ASC;
                    """#
            ) { sequence in
                try await sequence.collect()
                    .compactMap {
                        try $0.decode(column: "name", as: String?.self)
                    }
            }
        }

        public func getPermissionsBy(identityId: String) async throws
            -> [String]
        {
            let isRoot =
                try await connection.run(
                    query: #"""
                        SELECT is_root
                        FROM user_identity
                        WHERE id = \#(identityId)
                        LIMIT 1;
                        """#
                ) { sequence in
                    guard let row = try await sequence.collect().first else {
                        return false
                    }
                    return try row.decode(column: "is_root", as: Bool.self)
                }

            if isRoot {
                return try await connection.run(
                    query: #"""
                        SELECT name
                        FROM system_permission
                        ORDER BY name ASC;
                        """#
                ) { sequence in
                    try await sequence.collect()
                        .compactMap {
                            try $0.decode(column: "name", as: String?.self)
                        }
                }
            }

            return try await connection.run(
                query: #"""
                    SELECT DISTINCT sp.name
                    FROM user_identity_role uir
                    INNER JOIN auth_role_permission arp
                        ON arp.role_id = uir.role_id
                    INNER JOIN system_permission sp
                        ON sp.id = arp.permission_id
                    WHERE uir.identity_id = \#(identityId)
                    ORDER BY sp.name ASC;
                    """#
            ) { sequence in
                try await sequence.collect()
                    .compactMap {
                        try $0.decode(column: "name", as: String?.self)
                    }
            }
        }
    }
}
