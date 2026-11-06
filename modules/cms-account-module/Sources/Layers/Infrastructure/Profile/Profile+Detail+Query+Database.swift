public import AccountApplication
public import AccountModule
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure

extension Profile.Detail.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(userId: String) async throws -> Profile.Detail.Output {
            guard
                let detail = try await DatabaseAccessLayer<
                    Profile.Table
                >(
                    context: context
                )
                .selectFirst(
                    by: \.userId,
                    equals: userId,
                    as: Profile.Table.Detail.self
                )
            else {
                throw RepositoryError.notFound
            }
            return .init(
                userId: detail.userId,
                firstName: detail.firstName,
                lastName: detail.lastName,
                profileImageAssetId: detail.profileImageAssetId,
                createdAt: detail.createdAt,
                updatedAt: detail.updatedAt
            )
        }
    }
}
