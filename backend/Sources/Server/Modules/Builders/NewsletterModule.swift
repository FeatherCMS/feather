import Infrastructure
import NewsletterApplication
import NewsletterInfrastructure
import Application

struct NewsletterModule: Sendable {
    private let infrastructure: AppInfrastructure
    private let authorizer: any Authorizer

    init(
        infrastructure: AppInfrastructure,
        authorizer: any Authorizer
    ) {
        self.infrastructure = infrastructure
        self.authorizer = authorizer
    }

    func aggregatedPermissions() {
        for permission in NewsletterPermissions.allPermissions() {
            print(permission.rawValue)
        }
    }

    func authorize(permission: PermissionKey) async throws {
        let subject = try await CurrentSubject.require()
        guard try await authorizer.can(subject: subject, perform: NewsletterPermissionAction(key: permission)) else {
            throw AuthError(kind: .forbidden, message: permission.rawValue)
        }
    }

    private func transaction() -> DatabaseTransactionExecutor<WriteNewsletter> {
        DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteNewsletter(
                    newsletter: DatabaseNewsletterCampaignRepository(connection: connection),
                    subscriber: DatabaseNewsletterCampaignSubscriberRepository(connection: connection),
                    issue: DatabaseNewsletterCampaignIssueRepository(connection: connection),
                    delivery: DatabaseNewsletterCampaignDeliveryRepository(connection: connection)
                )
            }
        )
    }

    func makeCreateNewsletter() -> CreateNewsletter {
        .init(transaction: transaction(), idGenerator: infrastructure.idGenerator)
    }

    func makeListNewsletters() -> ListNewsletters { .init(transaction: transaction()) }
    func makeGetNewsletter() -> GetNewsletter { .init(transaction: transaction()) }
    func makeUpdateNewsletter() -> UpdateNewsletter { .init(transaction: transaction()) }
    func makeDeleteNewsletter() -> DeleteNewsletter { .init(transaction: transaction()) }

    func makeCreateNewsletterIssue() -> CreateNewsletterIssue {
        .init(transaction: transaction(), idGenerator: infrastructure.idGenerator)
    }

    func makeListNewsletterIssues() -> ListNewsletterIssues { .init(transaction: transaction()) }

    func makeScheduleNewsletterIssue() -> ScheduleNewsletterIssue {
        .init(transaction: transaction(), clock: DefaultClock())
    }

    func makeSubscribeToNewsletter() -> SubscribeToNewsletter {
        .init(transaction: transaction(), clock: DefaultClock())
    }

    func makeUnsubscribeFromNewsletter() -> UnsubscribeFromNewsletter {
        .init(transaction: transaction(), clock: DefaultClock())
    }

    func makeListNewsletterSubscribers() -> ListNewsletterSubscribers { .init(transaction: transaction()) }
    func makeGetNewsletterSubscriber() -> GetNewsletterSubscriber { .init(transaction: transaction()) }
    func makeCreateNewsletterSubscriber() -> CreateNewsletterSubscriber { .init(transaction: transaction(), clock: DefaultClock()) }
    func makeUpdateNewsletterSubscriber() -> UpdateNewsletterSubscriber { .init(transaction: transaction(), clock: DefaultClock()) }
    func makeDeleteNewsletterSubscriber() -> DeleteNewsletterSubscriber { .init(transaction: transaction()) }
}
