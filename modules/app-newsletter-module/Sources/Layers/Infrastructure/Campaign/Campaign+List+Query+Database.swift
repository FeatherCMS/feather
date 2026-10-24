import FeatherDBAL
public import FeatherInfrastructure
public import NewsletterApplication
public import NewsletterDomain
public import NewsletterModule

extension Campaign.Table.List {
    var asDomain: Campaign.Model {
        .init(
            id: id,
            key: key,
            name: name,
            fromEmail: fromEmail,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Campaign.List.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<Campaign.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func list() async throws -> [Campaign.Model] {
            try await accessLayer.select {
                $0.order(by: \.name).order(by: \.id)
            }
            .map(\.asDomain)
        }
    }
}
