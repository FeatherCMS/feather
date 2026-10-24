public import AccountApplication
public import AccountDomain
public import AccountModule
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure

extension Settings.Detail.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func get(userId: String) async throws -> Settings.Model {
            guard
                let detail = try await DatabaseAccessLayer<Settings.Table>(
                    context: context
                )
                .selectFirst(
                    by: \.userId,
                    equals: userId,
                    as: Settings.Table.Detail.self
                )
            else {
                throw RepositoryError.notFound
            }
            return .init(
                userId: detail.userId,
                language: detail.language,
                timezone: detail.timezone,
                pageSize: detail.pageSize,
                createdAt: detail.createdAt,
                updatedAt: detail.updatedAt
            )
        }
    }
}
