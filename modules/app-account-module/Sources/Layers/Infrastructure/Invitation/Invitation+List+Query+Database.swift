public import AccountApplication
public import AccountModule
import FeatherDBAL
public import FeatherInfrastructure

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
            return .init(items: try items.map { try $0.asListItem() })
        }
    }
}
