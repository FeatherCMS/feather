public import AuthApplication
public import AuthModule
import FeatherDBAL
public import FeatherInfrastructure

extension Email.List.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<Email.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func list() async throws -> Email.List.Output {
            let items =
                try await accessLayer
                .select(as: Email.Table.List.self) { $0 }
                .map {
                    Email.List.Output.Item(
                        id: $0.id,
                        identityId: $0.identityId,
                        email: $0.email
                    )
                }

            return .init(items: items)
        }
    }
}
