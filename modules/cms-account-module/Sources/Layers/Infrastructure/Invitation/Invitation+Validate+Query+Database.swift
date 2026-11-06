public import AccountApplication
public import AccountModule
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
import Foundation

extension Invitation.Validate.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(token: String) async throws
            -> Invitation.Validate.Output
        {
            guard
                let invitation = try await DatabaseAccessLayer<
                    Invitation.Table
                >(
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
            return Invitation.Validate.Output(
                id: invitation.id,
                userId: invitation.userId,
                email: invitation.email,
                token: invitation.token,
                roleIDs: try JSONDecoder()
                    .decode(
                        [String].self,
                        from: Data(invitation.roleIds.utf8)
                    ),
                expiresAt: invitation.expiresAt,
                createdAt: invitation.createdAt,
                updatedAt: invitation.updatedAt
            )
        }
    }
}
