public import AccountApplication
public import AccountModule
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure

extension Invitation.Validate.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func getBy(token: String) async throws -> Invitation.Validate.Output {
            guard
                let invitation = try await DatabaseAccessLayer<Invitation.Table>(
                    context: context
                )
                .selectFirst(
                    by: \.token,
                    equals: token,
                    as: Invitation.Table.Detail.self
                )
            else {
                throw RepositoryError.notFound
            }
            let detail = try invitation.asDetail()
            return .init(
                id: detail.id,
                userId: detail.userId,
                email: detail.email,
                token: detail.token,
                roleIDs: detail.roleIDs,
                expiresAt: detail.expiresAt,
                createdAt: detail.createdAt,
                updatedAt: detail.updatedAt
            )
        }
    }
}
