import FeatherApplication
import FeatherDBAL
import FeatherDBALTesting
import FeatherDatabase
import FeatherDatabaseTesting
import FeatherInfrastructure
import FeatherTesting
import NewsletterDomain
import NewsletterModule
import Testing

@testable import FeatherDBAL
@testable import NewsletterApplication
@testable import NewsletterInfrastructure

private enum NewsletterQueryKey: DatabaseQueryKey {
    case search
    case count
}

@Suite
struct NewsletterInfrastructureTests {

    @Test
    func subscriberSearchGroupsMembershipsAndAppliesDatabasePagination()
        async throws
    {
        let connection = MockDatabaseConnection<NewsletterQueryKey>(
            responses: [
                .init(
                    key: .search,
                    rows: [
                        .init([
                            "email": .string("person@example.com"),
                            "first_name": .string("Test"),
                            "last_name": .string("Person"),
                            "campaign_key": .string("weekly"),
                            "campaign_name": .string("Weekly"),
                            "status": .string("subscribed"),
                            "subscription_date": .date(
                                Date(timeIntervalSince1970: 100)
                            ),
                            "unsubscription_date": .null,
                        ]),
                        .init([
                            "email": .string("person@example.com"),
                            "first_name": .string("Test"),
                            "last_name": .string("Person"),
                            "campaign_key": .string("monthly"),
                            "campaign_name": .string("Monthly"),
                            "status": .string("unsubscribed"),
                            "subscription_date": .date(
                                Date(timeIntervalSince1970: 200)
                            ),
                            "unsubscription_date": .date(
                                Date(timeIntervalSince1970: 300)
                            ),
                        ]),
                    ]
                ),
                .init(key: .count, rows: [.init(["count": .int(1)])]),
            ]
        )
        let query = Subscriber.Search.Query.Database(
            context: DatabaseQueryContext(
                platform: MockDatabasePlatform(),
                connection: connection,
                idGenerator: FeatherTesting.IDGenerator.Mock(id: "unused")
            )
        )

        let result = try await query.search(
            query: .init(
                page: .init(size: 15, number: 2),
                sort: [.init(field: .email, direction: .desc)],
                search: "Person_%",
                campaignKey: "weekly"
            )
        )
        try await connection.assertAllResponsesConsumed()

        #expect(result.total == 1)
        #expect(result.items.count == 1)
        #expect(result.items[0].email == "person@example.com")
        #expect(result.items[0].name == "Test Person")
        #expect(
            result.items[0].memberships.map(\.campaignKey)
                == ["weekly", "monthly"]
        )
        #expect(
            result.items[0].memberships.map(\.status)
                == [.subscribed, .unsubscribed]
        )
        let queries = await connection.executedQueries()
        let search = try #require(queries[.search]?.first)
        #expect(search.sql.contains("COUNT") == false)
        #expect(search.sql.contains("ORDER BY email DESC"))
        #expect(search.sql.contains("LIMIT"))
        #expect(search.sql.contains("OFFSET"))
        #expect(search.bindings.contains(where: { $0.binding == .int(15) }))
        #expect(
            search.bindings.contains(where: {
                $0.binding == .string("%person!_!%%")
            })
        )
        #expect(
            search.bindings.contains(where: {
                $0.binding == .string("weekly")
            })
        )
        #expect(queries[.count]?.first?.sql.contains("COUNT(DISTINCT") == true)
    }

    @Test
    func subscriberSearchSortsByNameComponents() async throws {
        let connection = MockDatabaseConnection<NewsletterQueryKey>(
            responses: [
                .init(key: .search),
                .init(key: .count, rows: [.init(["count": .int(0)])]),
            ]
        )
        let query = Subscriber.Search.Query.Database(
            context: DatabaseQueryContext(
                platform: MockDatabasePlatform(),
                connection: connection,
                idGenerator: FeatherTesting.IDGenerator.Mock(id: "unused")
            )
        )

        let result = try await query.search(
            query: .init(sort: [.init(field: .name, direction: .asc)])
        )
        try await connection.assertAllResponsesConsumed()

        #expect(result.items.isEmpty)
        let queries = await connection.executedQueries()
        let search = try #require(queries[.search]?.first)
        #expect(search.sql.contains("ORDER BY first_name ASC, last_name ASC"))
        #expect(
            search.sql.contains(
                "ORDER BY paged.first_name ASC, paged.last_name ASC"
            )
        )
    }

    @Test
    func campaignSchemaDefinesIdentityTimestampsAndIndex() {
        let schema = Campaign.Table.tableCreationSchema

        #expect(schema.name == "newsletter_campaign")
        #expect(
            schema.columns.map(\.name) == [
                "id", "key", "name", "from_email", "created_at", "updated_at",
            ]
        )
        #expect(
            schema.constraints.contains {
                guard case .primaryKey(let columns) = $0 else { return false }
                return columns.map(\.name) == ["id"]
            }
        )
        #expect(
            schema.columns[1].constraints
                .contains {
                    if case .notNull = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(
            schema.columns[1].constraints
                .contains {
                    if case .unique = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        for index in [1, 2, 3] {
            #expect(
                schema.columns[index].constraints
                    .contains {
                        if case .notNull = $0 {
                            true
                        }
                        else {
                            false
                        }
                    }
            )
        }
        for column in [schema.columns[4], schema.columns[5]] {
            #expect(column.type == .timestamp)
            #expect(
                column.constraints.contains {
                    guard case .notNull = $0 else { return false }
                    return true
                }
            )
            #expect(
                column.constraints.contains {
                    guard case .default(let value) = $0 else { return false }
                    if case .currentTimestamp = value.storage { return true }
                    return false
                }
            )
        }
        #expect(schema.indexes.map(\.name) == ["newsletter_campaign_key_idx"])
        #expect(schema.indexes[0].columns.map(\.name) == ["key"])
    }

    @Test
    func subscriberSchemaDefinesCompositeKeyAndCampaignRelation() {
        let schema = Subscriber.Table.tableCreationSchema

        #expect(schema.name == "newsletter_subscriber")
        #expect(
            schema.columns.map(\.name) == [
                "newsletter_id", "email", "status", "subscription_date",
                "unsubscription_date", "first_name", "last_name",
                "confirmed_at",
                "unsubscribe_token", "source", "last_sent_at", "created_at",
                "updated_at",
            ]
        )
        #expect(
            schema.constraints.contains {
                guard case .primaryKey(let columns) = $0 else { return false }
                return columns.map(\.name) == ["newsletter_id", "email"]
            }
        )
        for index in [0, 1, 2, 3, 5, 6, 11, 12] {
            #expect(
                schema.columns[index].constraints
                    .contains {
                        if case .notNull = $0 {
                            true
                        }
                        else {
                            false
                        }
                    }
            )
        }
        #expect(
            schema.constraints.contains {
                guard
                    case .foreignKey(
                        let columns,
                        let table,
                        let referenced,
                        let onDelete,
                        _
                    ) = $0
                else { return false }
                guard case .cascade? = onDelete else { return false }
                return columns.map(\.name) == ["newsletter_id"]
                    && table == "newsletter_campaign"
                    && referenced.map(\.name) == ["id"]
            }
        )
        #expect(
            schema.columns[2].constraints
                .contains {
                    guard case .default(let value) = $0 else { return false }
                    guard case .string(let actual) = value.storage else {
                        return false
                    }
                    return actual == "subscribed"
                }
        )
        for column in [
            schema.columns[3], schema.columns[11], schema.columns[12],
        ] {
            #expect(column.type == .timestamp)
            #expect(
                column.constraints.contains {
                    guard case .notNull = $0 else { return false }
                    return true
                }
            )
            #expect(
                column.constraints.contains {
                    guard case .default(let value) = $0 else { return false }
                    if case .currentTimestamp = value.storage { return true }
                    return false
                }
            )
        }
        for column in [schema.columns[5], schema.columns[6]] {
            #expect(
                column.constraints.contains {
                    guard case .default(let value) = $0 else { return false }
                    guard case .string(let actual) = value.storage else {
                        return false
                    }
                    return actual.isEmpty
                }
            )
        }
        #expect(
            schema.columns[8].constraints
                .contains {
                    if case .unique = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(
            schema.indexes.map(\.name) == ["newsletter_subscriber_email_idx"]
        )
        #expect(schema.indexes[0].columns.map(\.name) == ["email"])
    }

    @Test
    func issueSchemaDefinesCampaignRelationAndUniqueCompositeKey() {
        let schema = Issue.Table.tableCreationSchema

        #expect(schema.name == "newsletter_issue")
        #expect(
            schema.columns.map(\.name) == [
                "id", "newsletter_id", "subject", "preview_text", "content",
                "status", "scheduled_date", "sent_date", "created_at",
                "updated_at",
            ]
        )
        #expect(
            schema.constraints.contains {
                guard case .primaryKey(let columns) = $0 else { return false }
                return columns.map(\.name) == ["id"]
            }
        )
        #expect(
            schema.constraints.contains {
                guard case .unique(let columns) = $0 else { return false }
                return columns.map(\.name) == ["id", "newsletter_id"]
            }
        )
        for index in [1, 2, 3, 4, 5] {
            #expect(
                schema.columns[index].constraints
                    .contains {
                        if case .notNull = $0 {
                            true
                        }
                        else {
                            false
                        }
                    }
            )
        }
        #expect(
            schema.constraints.contains {
                guard
                    case .foreignKey(
                        let columns,
                        let table,
                        let referenced,
                        _,
                        _
                    ) = $0
                else { return false }
                return columns.map(\.name) == ["newsletter_id"]
                    && table == "newsletter_campaign"
                    && referenced.map(\.name) == ["id"]
            }
        )
        #expect(
            schema.columns[3].constraints
                .contains {
                    guard case .default(let value) = $0 else { return false }
                    guard case .string(let actual) = value.storage else {
                        return false
                    }
                    return actual.isEmpty
                }
        )
        #expect(
            schema.columns[5].constraints
                .contains {
                    guard case .default(let value) = $0 else { return false }
                    guard case .string(let actual) = value.storage else {
                        return false
                    }
                    return actual == "draft"
                }
        )
        for column in [schema.columns[8], schema.columns[9]] {
            #expect(column.type == .timestamp)
            #expect(
                column.constraints.contains {
                    guard case .notNull = $0 else { return false }
                    return true
                }
            )
            #expect(
                column.constraints.contains {
                    guard case .default(let value) = $0 else { return false }
                    if case .currentTimestamp = value.storage { return true }
                    return false
                }
            )
        }
        #expect(
            schema.indexes.map(\.name) == ["newsletter_issue_newsletter_id_idx"]
        )
        #expect(schema.indexes[0].columns.map(\.name) == ["newsletter_id"])
    }

    @Test
    func deliverySchemaDefinesCompositeKeysAndIndexes() {
        let schema = Delivery.Table.tableCreationSchema

        #expect(schema.name == "newsletter_delivery")
        #expect(
            schema.columns.map(\.name) == [
                "issue_id", "newsletter_id", "subscriber_email", "status",
                "sent_date", "failure_reason", "created_at", "updated_at",
            ]
        )
        #expect(
            schema.constraints.contains {
                guard case .primaryKey(let columns) = $0 else { return false }
                return columns.map(\.name) == ["issue_id", "subscriber_email"]
            }
        )
        for index in [0, 1, 2, 3] {
            #expect(
                schema.columns[index].constraints
                    .contains {
                        if case .notNull = $0 {
                            true
                        }
                        else {
                            false
                        }
                    }
            )
        }
        #expect(
            schema.constraints.contains {
                guard
                    case .foreignKey(
                        let columns,
                        let table,
                        let referenced,
                        let onDelete,
                        _
                    ) = $0
                else { return false }
                guard case nil = onDelete else { return false }
                return columns.map(\.name) == ["issue_id", "newsletter_id"]
                    && table == Issue.Table.name
                    && referenced.map(\.name) == ["id", "newsletter_id"]
            }
        )
        #expect(
            schema.columns[3].constraints
                .contains {
                    guard case .default(let value) = $0 else { return false }
                    guard case .string(let actual) = value.storage else {
                        return false
                    }
                    return actual == "pending"
                }
        )
        for column in [schema.columns[6], schema.columns[7]] {
            #expect(column.type == .timestamp)
            #expect(
                column.constraints.contains {
                    guard case .notNull = $0 else { return false }
                    return true
                }
            )
            #expect(
                column.constraints.contains {
                    guard case .default(let value) = $0 else { return false }
                    if case .currentTimestamp = value.storage { return true }
                    return false
                }
            )
        }
        #expect(
            schema.indexes.map(\.name) == [
                "newsletter_delivery_status_idx",
                "newsletter_delivery_issue_newsletter_id_idx",
            ]
        )
        #expect(
            schema.indexes.map { $0.columns.map(\.name) } == [
                ["status"], ["issue_id", "newsletter_id"],
            ]
        )
    }
}
