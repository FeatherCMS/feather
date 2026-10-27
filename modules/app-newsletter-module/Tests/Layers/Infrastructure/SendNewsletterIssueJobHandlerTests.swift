import FeatherDBALTesting
import FeatherDatabase
import FeatherDatabaseTesting
import FeatherInfrastructure
import FeatherMail
import FeatherMailTesting
import FeatherTesting
import Foundation
import NewsletterModule
import Testing

@testable import NewsletterInfrastructure

private enum NewsletterDeliveryQueryKey: DatabaseQueryKey {
    case find
    case update
    case updated
}

@Suite
struct SendNewsletterIssueJobHandlerTests {

    private func deliveryRow(
        status: String,
        sentDate: Date?
    ) -> MockDatabaseRow {
        .init([
            "issue_id": .string("issue-1"),
            "newsletter_id": .string("newsletter-1"),
            "subscriber_email": .string("reader@example.com"),
            "status": .string(status),
            "sent_date": sentDate.map(MockDatabaseRow.Value.date) ?? .null,
            "failure_reason": .null,
            "created_at": .date(Date(timeIntervalSince1970: 100)),
            "updated_at": .date(Date(timeIntervalSince1970: 100)),
        ])
    }

    @Test
    func issueMailIncludesRecipientSpecificUnsubscribeLinkAndHeaders()
        async throws
    {
        let mailbox = TestMailbox()
        let mailClient = TestMailClient(mailbox: mailbox)
        let parameters = SendNewsletterIssueJobParameter(
            mail: .init(
                from: "newsletter@example.com",
                to: ["reader@example.com"],
                subject: "Issue subject",
                additionalHeaders: [],
                body: "<p>Issue content</p>",
                contentType: .html
            ),
            issueId: "issue-1",
            newsletterId: "newsletter-1",
            newsletterKey: "weekly",
            unsubscribeToken: "token-123"
        )

        try await SendMailJobHandler.handle(
            parameters: SendNewsletterIssueJobHandler.makeMailParameters(
                parameters: parameters,
                publicBaseURL: URL(string: "https://example.com")!
            ),
            mailClient: mailClient
        )

        let messages = await mailbox.getMessages()
        let message = try #require(messages.first)
        let unsubscribeURL =
            "https://example.com/newsletter/unsubscribe/token-123"
        #expect(messages.count == 1)
        #expect(message.to.map(\.email) == ["reader@example.com"])
        #expect(
            message.customHeaders.map(\.name)
                == ["List-Unsubscribe", "List-Unsubscribe-Post"]
        )
        #expect(message.customHeaders[0].value == "<\(unsubscribeURL)>")
        #expect(
            message.customHeaders[1].value == "List-Unsubscribe=One-Click"
        )
        if case .html(let body) = message.body {
            #expect(body.contains("<p>Issue content</p>"))
            #expect(body.contains("href=\"\(unsubscribeURL)\""))
        }
        else {
            Issue.record("Newsletter issue mail body was not HTML")
        }
    }

    @Test
    func issueJobSendsMailAndMarksDeliveryAsSent() async throws {
        let sentDate = Date(timeIntervalSince1970: 200)
        let connection = MockDatabaseConnection<NewsletterDeliveryQueryKey>(
            responses: [
                .init(
                    key: .find,
                    rows: [deliveryRow(status: "pending", sentDate: nil)]
                ),
                .init(key: .update),
                .init(
                    key: .updated,
                    rows: [deliveryRow(status: "sent", sentDate: sentDate)]
                ),
            ]
        )
        let databaseContext = DatabaseClientContext(
            database: FeatherTesting.DatabaseClient.Mock(
                connection: connection
            ),
            idGenerator: FeatherTesting.IDGenerator.Mock(id: "unused"),
            platform: MockDatabasePlatform()
        )
        let mailbox = TestMailbox()
        let mailClient = TestMailClient(mailbox: mailbox)
        let parameters = SendNewsletterIssueJobParameter(
            mail: .init(
                from: "newsletter@example.com",
                to: ["reader@example.com"],
                subject: "Issue subject",
                additionalHeaders: [],
                body: "<p>Issue content</p>",
                contentType: .html
            ),
            issueId: "issue-1",
            newsletterId: "newsletter-1",
            newsletterKey: "weekly",
            unsubscribeToken: "token-123"
        )

        try await SendNewsletterIssueJobHandler.handle(
            parameters: parameters,
            databaseContext: databaseContext,
            mailClient: mailClient,
            publicBaseURL: URL(string: "https://example.com")!
        )

        try await connection.assertAllResponsesConsumed()
        let messages = await mailbox.getMessages()
        let message = try #require(messages.first)
        let executedQueries = await connection.executedQueries()
        let updateQuery = try #require(executedQueries[.update]?.first)
        #expect(messages.count == 1)
        #expect(message.to.map(\.email) == ["reader@example.com"])
        #expect(
            message.customHeaders.map(\.name)
                == ["List-Unsubscribe", "List-Unsubscribe-Post"]
        )
        #expect(updateQuery.sql.contains("UPDATE \"newsletter_delivery\""))
        #expect(
            updateQuery.bindings.contains(where: {
                $0.binding == .string("sent")
            })
        )
    }
}
