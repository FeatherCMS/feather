public import AuthApplication
public import AuthModule
import FeatherDBAL
public import FeatherInfrastructure
import UserInfrastructure
import UserModule

extension AuthModule.Authorization.Roles.Query {
    public struct Database: Interface {
        private struct RoleID: DatabaseTableRowDecodable {
            let roleId: String

            enum CodingKeys: String, CodingKey {
                case roleId = "role_id"
            }
        }

        private struct RoleName: DatabaseTableRowDecodable {
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
    }
}
