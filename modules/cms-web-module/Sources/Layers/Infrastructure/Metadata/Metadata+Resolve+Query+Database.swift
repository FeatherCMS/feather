import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
import WebDomain
public import WebModule

extension Metadata.Resolve.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func resolve(
            referenceType: String,
            referenceIDs: [String]
        ) async throws -> Metadata.Resolve.Output {
            guard !referenceIDs.isEmpty else { return .init(items: []) }
            let rows = try await DatabaseAccessLayer<Metadata.Table>(
                context: context
            )
            .select(as: Metadata.Table.List.self) {
                $0.where(\.referenceType, equals: referenceType)
                    .where(\.referenceID, in: referenceIDs)
                    .order(by: \.referenceID, .ascending)
            }
            return .init(
                items: rows.map {
                    .init(
                        id: $0.id,
                        referenceType: $0.referenceType,
                        referenceID: $0.referenceID,
                        slug: $0.slug,
                        publicationDate: $0.publicationDate,
                        expirationDate: $0.expirationDate,
                        status: .init(rawValue: $0.status) ?? .draft,
                        title: $0.titleOverride ?? "",
                        createdAt: $0.createdAt,
                        updatedAt: $0.updatedAt
                    )
                }
            )
        }
    }
}
