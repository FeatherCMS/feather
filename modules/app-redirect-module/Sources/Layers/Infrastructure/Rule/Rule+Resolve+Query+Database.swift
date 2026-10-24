import FeatherDBAL
public import FeatherInfrastructure
public import RedirectApplication
public import RedirectModule

extension Rule.Resolve.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<Rule.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func resolve(source: String) async throws -> Rule.Resolve.Output?
        {
            guard
                let row = try await accessLayer.selectFirst(
                    by: \.source,
                    equals: source
                )
            else {
                return nil
            }
            guard
                let statusCode = Rule.StatusCode(
                    rawValue: row.statusCode
                )
            else {
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
