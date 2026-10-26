import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
import WebDomain
import WebModule

import struct Foundation.Date

extension WebApplication.Public.Metadata.List.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func list() async throws -> WebApplication.Public.Metadata.List.Output {
            let rows = try await DatabaseAccessLayer<Metadata.Table>(
                context: context
            )
            .select(as: Metadata.Table.List.self) {
                let now = Date()
                let availability = DatabaseQueryFilter<Metadata.Table>()
                    .isNull(\.expirationDate)
                    .or { $0.where(\.expirationDate, greaterThan: now) }
                return $0.where(\.status, equals: "published")
                    .where(\.publicationDate, lessThanOrEqualTo: now)
                    .where(availability)
                    .where(\.noIndex, equals: false)
                    .order(by: \.slug, .ascending)
                    .order(by: \.id, .ascending)
            }
            return .init(slugs: rows.map(\.slug))
        }
    }
}
