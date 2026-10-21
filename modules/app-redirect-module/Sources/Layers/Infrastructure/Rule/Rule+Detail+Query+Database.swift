import FeatherDBAL
import FeatherDatabase
import FeatherInfrastructure
import RedirectApplication
import RedirectModule

extension RedirectModule.Rule.Detail.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<RedirectModule.Rule.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func detail(id: String) async throws -> Output {
            guard let row = try await accessLayer.selectFirst(by: \.id, equals: id)
            else {
                throw RepositoryError.notFound
            }
            guard let statusCode = RedirectModule.Rule.StatusCode(
                rawValue: row.statusCode
            ) else {
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
