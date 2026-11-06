public import AuthApplication
public import AuthModule
import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
import Foundation

extension Session.Detail.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(id: String) async throws -> Session.Detail.Output {
            guard
                let row = try await DatabaseAccessLayer<Session.Table>(
                    context: context
                )
                .selectFirst(by: \.id, equals: id)
            else {
                throw RepositoryError.notFound
            }
            return .init(
                id: row.id,
                token: row.token,
                identityId: row.identityId,
                authenticationType: row.authenticationType,
                authenticationReference: row.authenticationReference,
                expiresAt: row.expiresAt.timeIntervalSince1970,
                isPersistent: row.isPersistent,
                createdAt: row.createdAt,
                updatedAt: row.updatedAt
            )
        }
    }
}
