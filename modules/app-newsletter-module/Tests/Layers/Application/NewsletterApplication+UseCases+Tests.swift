import FeatherApplication
import FeatherMail
import FeatherModuleKit
import FeatherTesting
import Foundation
import NewsletterDomain
import NewsletterModule
import Testing

@testable import NewsletterApplication

@Suite
struct NewsletterApplicationUseCasesTests {

    private actor IssueSendSubscriberRepositoryMock:
        Subscriber.Repository.Interface
    {
        private var subscribers: [Subscriber.Model]

        init(subscribers: [Subscriber.Model]) {
            self.subscribers = subscribers
        }

        func list(newsletterId: String) async throws -> [Subscriber.Model] {
            subscribers.filter { $0.newsletterId == newsletterId }
        }

        func findBy(
            newsletterId: String,
            email: String
        ) async throws -> Subscriber.Model? {
            subscribers.first {
                $0.newsletterId == newsletterId && $0.email == email
            }
        }

        func findBy(
            newsletterId: String,
            unsubscribeToken: String
        ) async throws -> Subscriber.Model? {
            subscribers.first {
                $0.newsletterId == newsletterId
                    && $0.unsubscribeToken == unsubscribeToken
            }
        }

        func insert(_ model: Subscriber.Model.New) async throws
            -> Subscriber.Model
        {
            let value = Subscriber.Model(
                newsletterId: model.newsletterId,
                email: model.email,
                status: model.status,
                subscriptionDate: model.subscriptionDate,
                unsubscriptionDate: model.unsubscriptionDate,
                firstName: model.firstName,
                lastName: model.lastName,
                confirmedAt: model.confirmedAt,
                unsubscribeToken: model.unsubscribeToken,
                source: model.source,
                lastSentAt: model.lastSentAt,
                createdAt: model.subscriptionDate,
                updatedAt: model.subscriptionDate
            )
            subscribers.append(value)
            return value
        }

        func update(_ model: Subscriber.Model) async throws -> Subscriber.Model
        {
            if let index = subscribers.firstIndex(where: {
                $0.newsletterId == model.newsletterId && $0.email == model.email
            }) {
                subscribers[index] = model
            }
            return model
        }

        func delete(
            newsletterId: String,
            emails: [String]
        ) async throws -> [String] {
            let deleted = subscribers.filter {
                $0.newsletterId == newsletterId && emails.contains($0.email)
            }
            subscribers.removeAll {
                $0.newsletterId == newsletterId && emails.contains($0.email)
            }
            return deleted.map(\.email)
        }
    }

    private actor IssueSendDeliveryRepositoryMock: Delivery.Repository.Interface
    {
        private var deliveries: [Delivery.Model]

        init(deliveries: [Delivery.Model] = []) {
            self.deliveries = deliveries
        }

        func list(issueId: String) async throws -> [Delivery.Model] {
            deliveries.filter { $0.issueId == issueId }
        }

        func findBy(
            issueId: String,
            subscriberEmail: String
        ) async throws -> Delivery.Model? {
            deliveries.first {
                $0.issueId == issueId
                    && $0.subscriberEmail == subscriberEmail
            }
        }

        func insert(_ model: Delivery.Model.New) async throws -> Delivery.Model
        {
            let now = Date()
            let value = Delivery.Model(
                issueId: model.issueId,
                newsletterId: model.newsletterId,
                subscriberEmail: model.subscriberEmail,
                status: model.status,
                sentDate: model.sentDate,
                failureReason: model.failureReason,
                createdAt: now,
                updatedAt: now
            )
            deliveries.append(value)
            return value
        }

        func update(_ model: Delivery.Model) async throws -> Delivery.Model {
            if let index = deliveries.firstIndex(where: {
                $0.issueId == model.issueId
                    && $0.subscriberEmail == model.subscriberEmail
            }) {
                deliveries[index] = model
            }
            return model
        }

        func delete(issueId: String) async throws {
            deliveries.removeAll { $0.issueId == issueId }
        }

        func current() -> [Delivery.Model] {
            deliveries
        }
    }

    private actor IssueSendJobsMock:
        NewsletterModule.Issue.JobController.Interface
    {
        enum EnqueueError: Error, CustomStringConvertible {
            case unavailable

            var description: String { "queue unavailable" }
        }

        struct EnqueuedIssue: Sendable {
            let mail: Mail
            let issueId: String
            let newsletterId: String
            let newsletterKey: String
            let unsubscribeToken: String
            let scheduledAt: Date?
        }

        private(set) var enqueuedIssues: [EnqueuedIssue] = []
        private var shouldFailEnqueue: Bool

        init(shouldFailEnqueue: Bool = false) {
            self.shouldFailEnqueue = shouldFailEnqueue
        }

        func setShouldFailEnqueue(_ value: Bool) {
            shouldFailEnqueue = value
        }

        func enqueue(_ mail: Mail) async throws {}

        func enqueueIssue(
            mail: Mail,
            issueId: String,
            newsletterId: String,
            newsletterKey: String,
            unsubscribeToken: String,
            scheduledAt: Date?
        ) async throws {
            if shouldFailEnqueue {
                throw EnqueueError.unavailable
            }
            enqueuedIssues.append(
                .init(
                    mail: mail,
                    issueId: issueId,
                    newsletterId: newsletterId,
                    newsletterKey: newsletterKey,
                    unsubscribeToken: unsubscribeToken,
                    scheduledAt: scheduledAt
                )
            )
        }
    }

    @Test
    func inputsAreSendableDTOs() {
        #expect(
            Campaign.Add.Input(key: "updates", name: "Updates").name
                == "Updates"
        )
        #expect(
            Issue.Add
                .Input(
                    campaignKey: "newsletter-1",
                    subject: "Subject",
                    content: "Content"
                )
                .content == "Content"
        )
        #expect(
            Subscriber.Subscribe
                .Input(
                    campaignKey: "newsletter-1",
                    email: "person@example.com"
                )
                .email == "person@example.com"
        )
    }

    @Test
    func searchSubscribersRequiresPermissionAndPassesQuery() async throws {
        let query = Subscriber.Search.Query.Mock(
            result: .init(items: [], total: 17)
        )
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Subscriber.Search.Scope(subscriber: query)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = Subscriber.Search.UseCase(
            authorizer: authorizer,
            query: executor
        )
        let input = Subscriber.Search.Input(
            query: .init(
                page: .init(size: 25, number: 3),
                search: "example",
                campaignKey: "weekly"
            )
        )

        let output = try await useCase.execute(
            subject: Subject(id: "admin"),
            input: input
        )

        #expect(output.total == 17)
        #expect(await authorizer.canCallCount == 1)
        #expect(await executor.runCallCount == 1)
        #expect(await query.lastQuery?.search == "example")
        #expect(await query.lastQuery?.campaignKey == "weekly")
    }

    @Test
    func searchSubscribersDoesNotQueryWhenForbidden() async {
        let query = Subscriber.Search.Query.Mock(
            result: .init(items: [], total: 0)
        )
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Subscriber.Search.Scope(subscriber: query)
        )
        let useCase = Subscriber.Search.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: false),
            query: executor
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "guest"),
                input: .init(query: .init())
            )
        }

        #expect(await executor.runCallCount == 0)
        #expect(await query.searchCallCount == 0)
    }

    @Test
    func subscriberCanSubscribeUnsubscribeByTokenAndSubscribeAgain()
        async throws
    {
        let campaignDate = Date(timeIntervalSince1970: 100)
        let campaign = Campaign.Model(
            id: "campaign-1",
            key: "weekly",
            name: "Weekly",
            fromEmail: "newsletter@example.com",
            createdAt: campaignDate,
            updatedAt: campaignDate
        )
        let campaignRepository = CampaignRepositoryMock(model: campaign)
        let subscriberRepository = SubscriberRepositoryMock()

        let subscribe = Subscriber.Subscribe.UseCase(
            transaction: FeatherTesting.TransactionExecutor.Mock(
                context: Subscriber.Subscribe.Scope(
                    newsletter: campaignRepository,
                    subscriber: subscriberRepository
                )
            )
        )
        let firstSubscription = try await subscribe.execute(
            input: .init(
                campaignKey: "weekly",
                email: "person@example.com",
                firstName: "Newsletter"
            )
        )
        let subscribedModel = try #require(await subscriberRepository.current())
        let token = try #require(subscribedModel.unsubscribeToken)

        let unsubscribe = Subscriber.Unsubscribe.UseCase(
            transaction: FeatherTesting.TransactionExecutor.Mock(
                context: Subscriber.Unsubscribe.Scope(
                    newsletter: campaignRepository,
                    subscriber: subscriberRepository
                )
            )
        )
        let unsubscription = try await unsubscribe.execute(
            input: .init(campaignKey: "weekly", token: token)
        )

        #expect(firstSubscription.status == .subscribed)
        #expect(token.count == 32)
        #expect(unsubscription.status == .unsubscribed)
        #expect(unsubscription.unsubscriptionDate != nil)

        let renewedSubscription = try await subscribe.execute(
            input: .init(
                campaignKey: "weekly",
                email: "person@example.com",
                firstName: "Renewed"
            )
        )
        let renewedModel = try #require(await subscriberRepository.current())

        #expect(renewedSubscription.status == .subscribed)
        #expect(renewedModel.firstName == "Renewed")
        #expect(renewedModel.unsubscribeToken == token)
        #expect(renewedModel.unsubscriptionDate == nil)
    }

    @Test
    func issueSendQueuesOnlySubscribedUndeliveredRecipients() async throws {
        let now = Date(timeIntervalSince1970: 100)
        let campaign = Campaign.Model(
            id: "campaign-1",
            key: "weekly",
            name: "Weekly",
            fromEmail: "newsletter@example.com",
            createdAt: now,
            updatedAt: now
        )
        let subscribers = IssueSendSubscriberRepositoryMock(
            subscribers: [
                .init(
                    newsletterId: "campaign-1",
                    email: "new@example.com",
                    status: .subscribed,
                    subscriptionDate: now,
                    unsubscriptionDate: nil,
                    firstName: "New",
                    lastName: "Reader",
                    confirmedAt: nil,
                    unsubscribeToken: nil,
                    source: nil,
                    lastSentAt: nil,
                    createdAt: now,
                    updatedAt: now
                ),
                .init(
                    newsletterId: "campaign-1",
                    email: "already-sent@example.com",
                    status: .subscribed,
                    subscriptionDate: now,
                    unsubscriptionDate: nil,
                    firstName: "Already",
                    lastName: "Sent",
                    confirmedAt: nil,
                    unsubscribeToken: "existing-token",
                    source: nil,
                    lastSentAt: nil,
                    createdAt: now,
                    updatedAt: now
                ),
                .init(
                    newsletterId: "campaign-1",
                    email: "unsubscribed@example.com",
                    status: .unsubscribed,
                    subscriptionDate: now,
                    unsubscriptionDate: now,
                    firstName: "Unsubscribed",
                    lastName: "Reader",
                    confirmedAt: nil,
                    unsubscribeToken: "unsubscribed-token",
                    source: nil,
                    lastSentAt: nil,
                    createdAt: now,
                    updatedAt: now
                ),
            ]
        )
        let delivery = Delivery.Model(
            issueId: "issue-1",
            newsletterId: "campaign-1",
            subscriberEmail: "already-sent@example.com",
            status: .sent,
            sentDate: now,
            failureReason: nil,
            createdAt: now,
            updatedAt: now
        )
        let deliveries = IssueSendDeliveryRepositoryMock(deliveries: [delivery])
        let jobs = IssueSendJobsMock()
        let useCase = NewsletterModule.Issue.Send.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            transaction: FeatherTesting.TransactionExecutor.Mock(
                context: NewsletterModule.Issue.Send.Scope(
                    newsletter: CampaignRepositoryMock(model: campaign),
                    subscriber: subscribers,
                    delivery: deliveries
                )
            ),
            jobs: jobs
        )

        let scheduledDate = now.addingTimeInterval(3_600)
        try await useCase.execute(
            subject: Subject(id: "admin"),
            input: .init(
                issueId: "issue-1",
                newsletterId: "campaign-1",
                subject: "Weekly update",
                content: "<p>Issue content</p>",
                scheduledDate: scheduledDate
            )
        )

        let queued = await jobs.enqueuedIssues
        let currentDeliveries = await deliveries.current()
        let updatedSubscribers = try await subscribers.list(
            newsletterId: "campaign-1"
        )
        let newlySubscribed = try #require(
            updatedSubscribers.first { $0.email == "new@example.com" }
        )
        #expect(queued.count == 1)
        #expect(queued[0].mail.to.map(\.email) == ["new@example.com"])
        #expect(queued[0].mail.from.email == "newsletter@example.com")
        #expect(queued[0].mail.subject == "Weekly update")
        #expect(queued[0].scheduledAt == scheduledDate)
        #expect(queued[0].newsletterKey == "weekly")
        #expect(queued[0].unsubscribeToken == newlySubscribed.unsubscribeToken)
        #expect(currentDeliveries.count == 2)
        #expect(
            currentDeliveries.first { $0.subscriberEmail == "new@example.com" }?
                .status
                == .pending
        )
    }

    @Test
    func issueSendMarksQueueFailureAndRetriesFailedDelivery() async throws {
        let now = Date(timeIntervalSince1970: 100)
        let campaign = Campaign.Model(
            id: "campaign-1",
            key: "weekly",
            name: "Weekly",
            fromEmail: "newsletter@example.com",
            createdAt: now,
            updatedAt: now
        )
        let subscribers = IssueSendSubscriberRepositoryMock(
            subscribers: [
                .init(
                    newsletterId: "campaign-1",
                    email: "reader@example.com",
                    status: .subscribed,
                    subscriptionDate: now,
                    unsubscriptionDate: nil,
                    firstName: "",
                    lastName: "",
                    confirmedAt: nil,
                    unsubscribeToken: "unsubscribe-token",
                    source: nil,
                    lastSentAt: nil,
                    createdAt: now,
                    updatedAt: now
                )
            ]
        )
        let deliveries = IssueSendDeliveryRepositoryMock()
        let jobs = IssueSendJobsMock(shouldFailEnqueue: true)
        let useCase = NewsletterModule.Issue.Send.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            transaction: FeatherTesting.TransactionExecutor.Mock(
                context: NewsletterModule.Issue.Send.Scope(
                    newsletter: CampaignRepositoryMock(model: campaign),
                    subscriber: subscribers,
                    delivery: deliveries
                )
            ),
            jobs: jobs
        )
        let input = NewsletterModule.Issue.Send.Input(
            issueId: "issue-1",
            newsletterId: "campaign-1",
            subject: "Weekly update",
            content: "<p>Issue content</p>",
            scheduledDate: nil
        )

        await #expect(throws: IssueSendJobsMock.EnqueueError.self) {
            try await useCase.execute(
                subject: Subject(id: "admin"),
                input: input
            )
        }

        let failedDelivery = try #require(
            await deliveries.current().first
        )
        #expect(failedDelivery.status == .failed)
        #expect(failedDelivery.failureReason == "queue unavailable")

        await jobs.setShouldFailEnqueue(false)
        try await useCase.execute(
            subject: Subject(id: "admin"),
            input: input
        )

        let queued = await jobs.enqueuedIssues
        let retriedDelivery = try #require(await deliveries.current().first)
        #expect(queued.count == 1)
        #expect(retriedDelivery.status == .pending)
        #expect(retriedDelivery.failureReason == nil)
    }
}
