import FeatherDBAL
public import FeatherInfrastructure
import WebDomain
public import WebApplication
public import WebModule

extension Menu.Lookup.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(key: String) async throws -> Output? {
            try await DatabaseAccessLayer<Menu.Table>(context: context)
                .selectFirst(by: \.key, equals: key)
                .map {
                    .init(
                        id: $0.id,
                        key: $0.key,
                        name: $0.name
                    )
                }
        }
    }
}
