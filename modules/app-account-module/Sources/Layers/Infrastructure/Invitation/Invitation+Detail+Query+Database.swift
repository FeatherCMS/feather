public import AccountApplication
public import AccountModule
import FeatherApplication
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
import Foundation

extension Invitation.Detail.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(id: String) async throws -> Invitation.Detail.Output {
            guard
                let detail = try await DatabaseAccessLayer<Invitation.Table>(
                    context: context
                )
                .selectFirst(
                    by: \.id,
                    equals: id,
                    as: Invitation.Table.Detail.self
                )
            else {
                throw RepositoryError.notFound
            }
            return Invitation.Detail.Output(
                id: detail.id,
                userId: detail.userId,
                email: detail.email,
                token: detail.token,
                roleIDs: try JSONDecoder()
                    .decode(
                        [String].self,
                        from: Data(detail.roleIds.utf8)
                    ),
                expiresAt: detail.expiresAt,
                createdAt: detail.createdAt,
                updatedAt: detail.updatedAt
            )
        }

    }
}
