public import AccountApplication
public import AccountModule
import FeatherDBAL
public import FeatherInfrastructure
import Foundation

extension Invitation.List.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<Invitation.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func list() async throws -> Invitation.List.Output {
            let items = try await accessLayer.select(
                as: Invitation.Table.List.self
            ) { $0 }
            return .init(
                items: try items.map { item in
                    Invitation.List.Output.Item(
                        id: item.id,
                        userId: item.userId,
                        email: item.email,
                        token: item.token,
                        roleIDs: try JSONDecoder()
                            .decode(
                                [String].self,
                                from: Data(item.roleIds.utf8)
                            ),
                        expiresAt: item.expiresAt,
                        createdAt: item.createdAt,
                        updatedAt: item.updatedAt
                    )
                }
            )
        }
    }
}
