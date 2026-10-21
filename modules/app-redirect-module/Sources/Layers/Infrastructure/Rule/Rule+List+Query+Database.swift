import FeatherDBAL
import FeatherDatabase
import FeatherInfrastructure
import RedirectApplication
import RedirectModule

extension RedirectModule.Rule.List.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<RedirectModule.Rule.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func list() async throws -> Output {
            let rows = try await accessLayer.select { query in
                query.order(by: .init(by: \.source, .ascending))
            }
            let items = try rows.map(mapItem)
            return .init(items: items)
        }

        private func mapItem(
            _ row: RedirectModule.Rule.Table.List
        ) throws -> Output.Item {
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
