public import AuthApplication
public import AuthModule
import FeatherDBAL
public import FeatherInfrastructure

extension Email.Detail.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<Email.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func find(id: String) async throws -> Email.Detail.Output {
            guard
                let row = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                )
            else {
                throw QueryError.notFound
            }

            return .init(
                id: row.id,
                identityId: row.identityId,
                email: row.email
            )
        }
    }
}
