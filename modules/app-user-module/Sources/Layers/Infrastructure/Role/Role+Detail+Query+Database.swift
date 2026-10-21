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
            guard
                let row = try await DatabaseAccessLayer<Role.Table>(
                    context: context
                )
                .selectFirst(by: \.id, equals: id, as: Role.Table.Row.self)
            else {
                throw RepositoryError.notFound
            }
            return row.asDetail
        }
    }
}
