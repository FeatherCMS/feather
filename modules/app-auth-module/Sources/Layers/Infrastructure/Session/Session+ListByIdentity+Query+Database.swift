public import AuthApplication
public import AuthModule
import FeatherDBAL
public import FeatherInfrastructure

extension Session.ListByIdentity.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func list(identityId: String) async throws -> Output {
            let accessLayer = DatabaseAccessLayer<Session.Table>(
                context: context
            )
            let rows = try await accessLayer.select(
                as: Session.Table.List.self
            ) {
                $0.where(\.identityId, equals: identityId)
                    .order(by: \.id, .ascending)
            }
            return .init(
                items: rows.map {
                    .init(
                        id: $0.id,
                        token: $0.token,
                        identityId: $0.identityId,
                        authenticationType: $0.authenticationType,
                        authenticationReference: $0.authenticationReference,
                        expiresAt: $0.expiresAt.timeIntervalSince1970,
                        isPersistent: $0.isPersistent,
                        createdAt: $0.createdAt,
                        updatedAt: $0.updatedAt
                    )
                }
            )
        }
    }
}
