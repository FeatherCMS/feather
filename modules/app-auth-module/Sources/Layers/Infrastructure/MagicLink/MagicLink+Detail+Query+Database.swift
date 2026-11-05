public import AuthApplication
public import AuthModule
import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
import Foundation

extension MagicLink.Table.Detail {
    var asDetail: MagicLink.Detail.Output {
        .init(
            id: id,
            authEmailId: authEmailId,
            token: token,
            expiresAt: expiresAt,
            isPersistent: isPersistent,
            isUsed: isUsed,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension MagicLink.Detail.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(id: String) async throws -> MagicLink.Detail.Output {
            guard
                let row = try await DatabaseAccessLayer<MagicLink.Table>(
                    context: context
                )
                .selectFirst(by: \.id, equals: id)
            else {
                throw RepositoryError.notFound
            }
            return row.asDetail
        }
    }
}
