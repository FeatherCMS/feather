import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import UserApplication
import UserDomain
public import UserModule

extension Role.Table.Row {
    var asDetail: Role.Detail.Output {
        .init(
            id: id,
            key: key,
            name: name,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Role.Detail.Query {
    public struct Database: Role.Detail.Query.Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(id: String) async throws -> Role.Detail.Output {
            let table = Role.Table(connection: context.connection)
            guard let row = try await table.find(id: id) else {
                throw RepositoryError.notFound
            }
            return row.asDetail
        }
    }
}
