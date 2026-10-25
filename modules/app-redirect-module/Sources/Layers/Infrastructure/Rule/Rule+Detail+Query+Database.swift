import FeatherDBAL
public import FeatherInfrastructure
public import RedirectApplication
import RedirectDomain
public import RedirectModule

extension Rule.Detail.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<Rule.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func find(id: String) async throws -> Rule.Detail.Output {
            guard
                let row = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                )
            else {
                throw RepositoryError.notFound
            }
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
                statusCode: statusCode,
                notes: row.notes,
                createdAt: row.createdAt,
                updatedAt: row.updatedAt
            )
        }
    }
}
