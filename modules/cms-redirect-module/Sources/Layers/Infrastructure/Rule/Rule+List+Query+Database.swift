import FeatherDBAL
public import FeatherInfrastructure
public import RedirectApplication
import RedirectDomain
public import RedirectModule

extension Rule.List.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<Rule.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func list() async throws -> Rule.List.Output {
            let rows = try await accessLayer.select { query in
                query.order(
                    by: [
                        DatabaseQueryOrder<Rule.Table>(
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
            _ row: Rule.Table.List
        ) throws -> Rule.List.Output.Item {
            guard
                let statusCode = Rule.Model.StatusCode(
                    rawValue: row.statusCode
                )
            else {
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
