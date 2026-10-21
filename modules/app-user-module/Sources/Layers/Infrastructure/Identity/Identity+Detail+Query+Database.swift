import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import UserApplication
import UserDomain
public import UserModule

extension Identity.Table.Detail {
    func asDetail(roleIds: [String]) -> Identity.Detail.Output {
        .init(
            id: id,
            name: name,
            roleIds: roleIds,
            status: .init(rawValue: status) ?? .deactivated,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Identity.Detail.Query {
    public struct Database: Identity.Detail.Query.Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(id: String) async throws -> Identity.Detail.Output {
            let accessLayer = DatabaseAccessLayer<Identity.Table>(
                context: context
            )
            guard
                let row = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id,
                    as: Identity.Table.Detail.self
                )
            else {
                throw RepositoryError.notFound
            }
            let roleIds = try await DatabaseAccessLayer<
                IdentityRole.Table
            >(context: context)
            .select(as: IdentityRole.Table.RoleID.self) {
                $0.where(\.identityId, equals: id)
                    .order(by: [.init(by: \.roleId)])
            }
            .map(\.roleId)
            return row.asDetail(roleIds: roleIds)
        }
    }
}
