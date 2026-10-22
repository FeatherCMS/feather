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

        public func getBy(id: String) async throws -> Invitation.Detail.Output {
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
            return try detail.asDetail()
        }

        public func getBy(token: String) async throws
            -> Invitation.Detail.Output
        {
            guard
                let detail = try await DatabaseAccessLayer<Invitation.Table>(
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
            return try detail.asDetail()
        }

    }
}
