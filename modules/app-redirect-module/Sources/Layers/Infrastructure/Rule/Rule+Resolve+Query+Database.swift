import FeatherDBAL
import FeatherDatabase
import FeatherInfrastructure
import RedirectApplication
import RedirectModule

extension RedirectModule.Rule.Resolve.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<RedirectModule.Rule.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func resolve(source: String) async throws -> Output? {
            guard let row = try await accessLayer.selectFirst(
                by: \.source,
                equals: source
            ) else {
                return nil
            }
            guard let statusCode = RedirectModule.Rule.StatusCode(
                rawValue: row.statusCode
            ) else {
                throw RepositoryError.invalidEnumValue(String(row.statusCode))
            }
            return .init(
                source: row.source,
                destination: row.destination,
                statusCode: statusCode
            )
        }
    }
}
