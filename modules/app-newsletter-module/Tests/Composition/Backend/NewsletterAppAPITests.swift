import FeatherDBALTesting
import FeatherDatabase
import FeatherDatabaseTesting
import FeatherInfrastructure
import FeatherMail
import FeatherModuleKit
import FeatherTesting
import Foundation
import NewsletterAppAPI
import NewsletterApplication
import NewsletterBackend
import NewsletterModule
import Testing

private enum NewsletterAppAPIQueryKey: DatabaseQueryKey {
    case campaignLookup
    case subscriberLookup
    case subscriberInsert
    case subscriberRead
    case subscriberUpdate
    case subscriberUpdatedRead
}

private struct NewsletterAppAPIJobsMock:
    NewsletterModule.Issue.JobController.Interface
{
    func enqueue(_ mail: Mail) async throws {}

    func enqueueIssue(
        mail: Mail,
        issueId: String,
        newsletterId: String,
        newsletterKey: String,
        unsubscribeToken: String,
        scheduledAt: Date?
    ) async throws {}
}

@Suite
struct NewsletterAppAPITests {

    private func campaignRow() -> MockDatabaseRow {
        .init([
            "id": .string("campaign-1"),
            "key": .string("weekly"),
            "name": .string("Weekly"),
            "from_email": .string("newsletter@example.com"),
            "created_at": .date(Date(timeIntervalSince1970: 100)),
            "updated_at": .date(Date(timeIntervalSince1970: 100)),
        ])
    }

    private func subscriberRow(
        status: String,
        unsubscriptionDate: Date?
    ) -> MockDatabaseRow {
        .init([
            "newsletter_id": .string("campaign-1"),
            "email": .string("person@example.com"),
            "status": .string(status),
            "subscription_date": .date(Date(timeIntervalSince1970: 100)),
            "unsubscription_date": unsubscriptionDate.map(
                MockDatabaseRow.Value.date
            ) ?? .null,
            "first_name": .string("Ada"),
            "last_name": .string("Lovelace"),
            "confirmed_at": .null,
            "unsubscribe_token": .string("unsubscribe-token"),
            "source": .null,
            "last_sent_at": .null,
            "created_at": .date(Date(timeIntervalSince1970: 100)),
            "updated_at": .date(Date(timeIntervalSince1970: 100)),
        ])
    }

    private func gateway(
        connection: MockDatabaseConnection<NewsletterAppAPIQueryKey>
    ) -> NewsletterBackend.AppAPIGateway {
        let databaseContext = DatabaseClientContext(
            database: FeatherTesting.DatabaseClient.Mock(
                connection: connection
            ),
            idGenerator: FeatherTesting.IDGenerator.Mock(id: "unused"),
            platform: MockDatabasePlatform()
        )
        return NewsletterBackend.AppAPIGateway(
            useCases: NewsletterBackend.UseCases(
                databaseContext: databaseContext,
                authorizer: FeatherTesting.Authorizer.Mock(result: true),
                jobs: NewsletterAppAPIJobsMock()
            )
        )
    }

    @Test
    func subscribeAPIStoresSubscriberForCampaign() async throws {
        let connection = MockDatabaseConnection<NewsletterAppAPIQueryKey>(
            responses: [
                .init(key: .campaignLookup, rows: [campaignRow()]),
                .init(key: .subscriberLookup),
                .init(key: .subscriberInsert),
                .init(
                    key: .subscriberRead,
                    rows: [
                        subscriberRow(
                            status: "subscribed",
                            unsubscriptionDate: nil
                        )
                    ]
                ),
            ]
        )
        let gateway = gateway(connection: connection)

        let output = try await gateway.appNewsletterCampaignSubscribe(
            .init(
                path: .init(newsletterCampaignKey: "weekly"),
                body: .json(
                    .init(
                        email: "person@example.com",
                        firstName: "Ada",
                        lastName: "Lovelace"
                    )
                )
            )
        )

        try await connection.assertAllResponsesConsumed()
        #expect(output == .noContent)
        let queries = await connection.executedQueries()
        #expect(
            queries[.subscriberInsert]?.first?.bindings
                .contains(where: {
                    $0.binding == .string("person@example.com")
                }) == true
        )
    }

    @Test
    func unsubscribeAPIChangesSubscriberStatusByToken() async throws {
        let connection = MockDatabaseConnection<NewsletterAppAPIQueryKey>(
            responses: [
                .init(
                    key: .subscriberLookup,
                    rows: [
                        subscriberRow(
                            status: "subscribed",
                            unsubscriptionDate: nil
                        )
                    ]
                ),
                .init(key: .subscriberUpdate),
                .init(
                    key: .subscriberUpdatedRead,
                    rows: [
                        subscriberRow(
                            status: "unsubscribed",
                            unsubscriptionDate: Date(timeIntervalSince1970: 200)
                        )
                    ]
                ),
            ]
        )
        let gateway = gateway(connection: connection)

        let output = try await gateway.appNewsletterCampaignUnsubscribe(
            .init(
                body: .json(.init(token: "unsubscribe-token"))
            )
        )

        try await connection.assertAllResponsesConsumed()
        #expect(output == .noContent)
        let queries = await connection.executedQueries()
        let update = try #require(queries[.subscriberUpdate]?.first)
        #expect(update.sql.contains("UPDATE \"newsletter_subscriber\""))
        #expect(
            update.bindings.contains(where: {
                $0.binding == .string("unsubscribed")
            })
        )
    }
}
