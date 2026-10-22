public import WebApplication
public import WebDomain
import FeatherDBAL
public import FeatherInfrastructure

extension Metadata.Table.List {
    var asListItem: Metadata.List.Output.Item {
        .init(
            id: id,
            referenceType: referenceType,
            referenceID: referenceID,
            slug: slug,
            publicationDate: publicationDate,
            expirationDate: expirationDate,
            status: .init(rawValue: status) ?? .draft,
            title: titleOverride ?? "",
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Metadata.List.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func list() async throws -> Metadata.List.Output {
            let items = try await DatabaseAccessLayer<Metadata.Table>(
                context: context
            )
            .select(as: Metadata.Table.List.self) {
                $0.order(by: \.createdAt, .descending)
                    .order(by: \.id, .ascending)
                    .limit(10_000)
            }
            return .init(items: items.map(\.asListItem))
        }
    }
}
