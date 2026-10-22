import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
public import WebDomain

extension Menu.List.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func list() async throws -> Menu.List.Output {
            let rows = try await DatabaseAccessLayer<Menu.Table>(
                context: context
            )
            .select {
                $0.order(by: \.key, .ascending)
                    .order(by: \.id, .ascending)
                    .limit(10_000)
            }
            return .init(
                items: rows.map {
                    .init(
                        id: $0.id,
                        key: $0.key,
                        name: $0.name,
                        createdAt: $0.createdAt,
                        updatedAt: $0.updatedAt
                    )
                }
            )
        }
    }
}
