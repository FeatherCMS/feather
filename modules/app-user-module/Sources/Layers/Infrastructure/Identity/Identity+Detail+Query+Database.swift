import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import UserApplication
import UserDomain
public import UserModule

extension Identity.Table.Row {
    func asDetail(roleIds: [String]) -> Identity.Detail.Output {
        .init(
            id: id,
            name: name,
            roleIds: roleIds,
            status: .init(rawValue: status) ?? .deactivated,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Identity.Detail.Query {
    public struct Database: Identity.Detail.Query.Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(id: String) async throws -> Identity.Detail.Output {
            let table = Identity.Table(connection: context.connection)
            guard let row = try await table.find(id: id) else {
                throw RepositoryError.notFound
            }
            let roleIds = try await table.listRoleIds(identityId: id)
            return row.asDetail(roleIds: roleIds)
        }
    }
}
