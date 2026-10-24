import FeatherApplication
import FeatherDBAL
import FeatherDatabase
public import FeatherInfrastructure
import Foundation
public import NewsletterApplication
import NewsletterDomain
public import NewsletterModule

extension Subscriber.Search.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(query: Subscriber.Search.Input.Query) async throws
            -> Subscriber.Search.Output
        {
            let page = query.page.normalized()
            let pageNumber = page.number - 1
            let offset =
                pageNumber > Int.max / page.size
                ? Int.max
                : pageNumber * page.size
            let pattern = query.search.map(Self.searchPattern)
            let order = databaseOrder(for: query.sort)
            let finalOrder = databaseOrder(
                for: query.sort,
                qualifiedBy: "paged"
            )

            let rows = try await context.connection.run(
                query: searchItemsQuery(
                    pattern: pattern,
                    campaignKey: query.campaignKey,
                    email: query.email,
                    limit: page.size,
                    offset: offset,
                    order: order,
                    finalOrder: finalOrder
                )
            ) { sequence in
                try await sequence.collect()
            }

            let count = try await context.connection.run(
                query: countQuery(
                    pattern: pattern,
                    campaignKey: query.campaignKey,
                    email: query.email
                )
            ) { sequence in
                guard let row = try await sequence.collect().first else {
                    return 0
                }
                return try row.decode(column: "count", as: Int.self)
            }

            var items: [Subscriber.Search.Output.Item] = []
            for row in rows {
                let item = try SubscriberSearchRow(from: row)
                let membership = Subscriber.Search.Output.Membership(
                    campaignKey: item.campaignKey,
                    campaignName: item.campaignName,
                    status: try status(from: item.status)
                )
                if let lastIndex = items.indices.last,
                    items[lastIndex].email == item.email
                {
                    let current = items[lastIndex]
                    items[lastIndex] = .init(
                        email: current.email,
                        name: current.name,
                        memberships: current.memberships + [membership]
                    )
                }
                else {
                    items.append(
                        .init(
                            email: item.email,
                            name: [item.firstName, item.lastName]
                                .filter { !$0.isEmpty }
                                .joined(separator: " "),
                            memberships: [membership]
                        )
                    )
                }
            }
            return .init(items: items, total: count)
        }

        private func searchItemsQuery(
            pattern: String?,
            campaignKey: String?,
            email: String?,
            limit: Int,
            offset: Int,
            order: String,
            finalOrder: String
        ) -> DatabaseQuery {
            var sql = DatabaseQuery.StringInterpolation(
                literalCapacity: 1200,
                interpolationCount: 11
            )
            sql.appendLiteral(
                """
                WITH matching_emails AS (
                    SELECT subscriber.email,
                           MAX(subscriber.first_name) AS first_name,
                           MAX(subscriber.last_name) AS last_name
                    FROM newsletter_subscriber AS subscriber
                    JOIN newsletter_campaign AS campaign
                      ON campaign.id = subscriber.newsletter_id
                    WHERE (
                """
            )
            appendFilters(
                &sql,
                pattern: pattern,
                campaignKey: campaignKey,
                email: email
            )
            sql.appendLiteral(
                """
                    )
                    GROUP BY subscriber.email
                ), paged_emails AS (
                    SELECT email, first_name, last_name
                    FROM matching_emails
                """
            )
            sql.appendLiteral(" ORDER BY ")
            sql.appendLiteral(order)
            sql.appendLiteral(" LIMIT ")
            sql.appendInterpolation(limit)
            sql.appendLiteral(" OFFSET ")
            sql.appendInterpolation(offset)
            sql.appendLiteral(
                """
                    )
                SELECT paged.email, paged.first_name, paged.last_name,
                       campaign.key AS campaign_key,
                       campaign.name AS campaign_name,
                       subscriber.status
                FROM paged_emails AS paged
                JOIN newsletter_subscriber AS subscriber
                  ON subscriber.email = paged.email
                JOIN newsletter_campaign AS campaign
                  ON campaign.id = subscriber.newsletter_id
                """
            )
            sql.appendLiteral(" ORDER BY ")
            sql.appendLiteral(finalOrder)
            sql.appendLiteral(", paged.email ASC, campaign.name ASC")
            return DatabaseQuery(stringInterpolation: sql)
        }

        private func countQuery(
            pattern: String?,
            campaignKey: String?,
            email: String?
        ) -> DatabaseQuery {
            var sql = DatabaseQuery.StringInterpolation(
                literalCapacity: 500,
                interpolationCount: 9
            )
            sql.appendLiteral(
                """
                SELECT COUNT(DISTINCT subscriber.email) AS count
                FROM newsletter_subscriber AS subscriber
                JOIN newsletter_campaign AS campaign
                  ON campaign.id = subscriber.newsletter_id
                WHERE (
                """
            )
            appendFilters(
                &sql,
                pattern: pattern,
                campaignKey: campaignKey,
                email: email
            )
            sql.appendLiteral(")")
            return DatabaseQuery(stringInterpolation: sql)
        }

        private func appendFilters(
            _ sql: inout DatabaseQuery.StringInterpolation,
            pattern: String?,
            campaignKey: String?,
            email: String?
        ) {
            sql.appendInterpolation(pattern)
            sql.appendLiteral(" IS NULL OR LOWER(subscriber.email) LIKE ")
            sql.appendInterpolation(pattern)
            sql.appendLiteral(" ESCAPE '!'")
            sql.appendLiteral(" OR LOWER(subscriber.first_name) LIKE ")
            sql.appendInterpolation(pattern)
            sql.appendLiteral(" ESCAPE '!'")
            sql.appendLiteral(" OR LOWER(subscriber.status) LIKE ")
            sql.appendInterpolation(pattern)
            sql.appendLiteral(" ESCAPE '!'")
            sql.appendLiteral(" OR LOWER(subscriber.last_name) LIKE ")
            sql.appendInterpolation(pattern)
            sql.appendLiteral(" ESCAPE '!') AND (")
            sql.appendInterpolation(campaignKey)
            sql.appendLiteral(" IS NULL OR campaign.key = ")
            sql.appendInterpolation(campaignKey)
            sql.appendLiteral(") AND (")
            sql.appendInterpolation(email)
            sql.appendLiteral(" IS NULL OR subscriber.email = ")
            sql.appendInterpolation(email)
            sql.appendLiteral(")")
        }

        private func databaseOrder(
            for sorts: [Subscriber.Search.Input.Query.Sort],
            qualifiedBy table: String? = nil
        ) -> String {
            let prefix = table.map { "\($0)." } ?? ""
            guard let sort = sorts.first else { return "\(prefix)email ASC" }
            let columns: [String]
            switch sort.field {
            case .email:
                columns = ["email"]
            case .name:
                columns = ["first_name", "last_name"]
            }
            let direction = sort.direction == .asc ? "ASC" : "DESC"
            return
                columns
                .map { "\(prefix)\($0) \(direction)" }
                .joined(separator: ", ")
        }

        private static func searchPattern(_ value: String) -> String {
            "%"
                + value.lowercased()
                .replacingOccurrences(of: "!", with: "!!")
                .replacingOccurrences(of: "%", with: "!%")
                .replacingOccurrences(of: "_", with: "!_") + "%"
        }

        private func status(from rawValue: String) throws
            -> Subscriber.Model.Status
        {
            guard let status = Subscriber.Model.Status(rawValue: rawValue)
            else {
                throw RepositoryError.invalidEnumValue(rawValue)
            }
            return status
        }
    }
}

private struct SubscriberSearchRow {
    let email: String
    let firstName: String
    let lastName: String
    let campaignKey: String
    let campaignName: String
    let status: String

    init(from row: any DatabaseRow) throws {
        email = try row.decode(column: "email", as: String.self)
        firstName = try row.decode(column: "first_name", as: String.self)
        lastName = try row.decode(column: "last_name", as: String.self)
        campaignKey = try row.decode(column: "campaign_key", as: String.self)
        campaignName = try row.decode(column: "campaign_name", as: String.self)
        status = try row.decode(column: "status", as: String.self)
    }
}
