import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
public import WebDomain

extension Menu.Table.Detail {
    var asDetail: MenuDetail {
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

extension Menu.Detail.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(id: String) async throws -> Menu.Detail.Output {
            guard
                let row = try await DatabaseAccessLayer<Menu.Table>(
                    context: context
                )
                .selectFirst(by: \.id, equals: id)
            else {
                throw RepositoryError.notFound
            }
            let detail = row.asDetail
            return .init(
                id: detail.id,
                key: detail.key,
                name: detail.name,
                notes: detail.notes,
                createdAt: detail.createdAt,
                updatedAt: detail.updatedAt
            )
        }

        public func find(key: String) async throws -> Menu.Detail.Output? {
            try await DatabaseAccessLayer<Menu.Table>(context: context)
                .selectFirst(by: \.key, equals: key)
                .map { row in
                    let detail = row.asDetail
                    return .init(
                        id: detail.id,
                        key: detail.key,
                        name: detail.name,
                        notes: detail.notes,
                        createdAt: detail.createdAt,
                        updatedAt: detail.updatedAt
                    )
                }
        }
    }
}
