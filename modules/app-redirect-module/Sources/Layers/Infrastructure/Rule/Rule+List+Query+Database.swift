import FeatherDBAL
public import FeatherInfrastructure
public import RedirectApplication
public import RedirectModule

extension RedirectModule.Rule.List.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<RedirectModule.Rule.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func list() async throws -> RedirectModule.Rule.List.Output {
            let rows = try await accessLayer.select { query in
                query.order(
                    by: [
                        DatabaseQueryOrder<RedirectModule.Rule.Table>(
                            by: \.source,
                            .ascending
                        )
                    ]
                )
            }
            let items = try rows.map(mapItem)
            return .init(items: items)
        }

        private func mapItem(
            _ row: RedirectModule.Rule.Table.List
        ) throws -> RedirectModule.Rule.List.Output.Item {
            guard let statusCode = RedirectModule.Rule.StatusCode(
                rawValue: row.statusCode
            ) else {
                throw RepositoryError.invalidEnumValue(String(row.statusCode))
            }
            return .init(
                id: row.id,
                source: row.source,
                destination: row.destination,
                statusCode: statusCode
            )
        }
    }
}
