import FeatherDBAL
public import FeatherInfrastructure
public import NewsletterApplication
public import NewsletterModule

extension Campaign.List.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<Campaign.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func list() async throws -> Campaign.List.Output {
            let rows = try await accessLayer.select {
                $0.order(by: \.name).order(by: \.id)
            }
            return .init(
                items: rows.map {
                    .init(
                        id: $0.id,
                        key: $0.key,
                        name: $0.name,
                        fromEmail: $0.fromEmail,
                        createdAt: $0.createdAt,
                        updatedAt: $0.updatedAt
                    )
                }
            )
        }
    }
}
