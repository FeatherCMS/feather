public import FeatherApplication
import FeatherMail
public import FeatherModuleKit
import Foundation
import NewsletterDomain
public import NewsletterModule

extension Issue.Send {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Scope>
        let jobs: any Issue.JobController.Interface

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Scope>,
            jobs: any Issue.JobController.Interface
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
            self.jobs = jobs
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws {
            let campaignReadAction = CampaignReadAction()
            guard
                try await authorizer.can(
                    subject: subject,
                    perform: campaignReadAction
                )
            else {
                throw AuthError(
                    kind: .forbidden,
                    message: campaignReadAction.key.rawValue
                )
            }

            let subscriberListAction = SubscriberListAction()
            guard
                try await authorizer.can(
                    subject: subject,
                    perform: subscriberListAction
                )
            else {
                throw AuthError(
                    kind: .forbidden,
                    message: subscriberListAction.key.rawValue
                )
            }

            let newsletter = try await transaction.run { scope in
                guard
                    let newsletter = try await scope.newsletter.findBy(
                        id: input.newsletterId
                    )
                else {
                    throw Error.newsletterNotFound
                }
                return newsletter
            }
            guard !newsletter.fromEmail.isEmpty else { return }

            let subscribers = try await transaction.run { scope in
                try await scope.subscriber.list(
                    newsletterId: input.newsletterId
                )
            }
            let recipients = subscribers.filter { $0.status == .subscribed }
            if input.scheduledDate == nil {
                try await transaction.run { scope in
                    let deliveries = try await scope.delivery.list(
                        issueId: input.issueId
                    )
                    let deliveriesByEmail = Dictionary(
                        uniqueKeysWithValues: deliveries.map {
                            ($0.subscriberEmail, $0)
                        }
                    )
                    let hasDeliveriesToQueue = recipients.contains { recipient in
                        guard
                            let delivery = deliveriesByEmail[recipient.email]
                        else {
                            return true
                        }
                        return delivery.status == .failed
                    }
                    let hasPendingDeliveries = deliveries.contains {
                        $0.status == .pending
                    }
                    guard
                        var issue = try await scope.issue.findBy(
                            id: input.issueId
                        )
                    else {
                        throw Error.issueNotFound
                    }
                    if hasDeliveriesToQueue || hasPendingDeliveries {
                        issue.status = .sending
                        issue.sentDate = nil
                    }
                    else if deliveries.contains(where: {
                        $0.status == .failed || $0.status == .bounced
                    }) {
                        issue.status = .failed
                        issue.sentDate = nil
                    }
                    else {
                        issue.status = .sent
                        issue.sentDate = Date()
                    }
                    _ = try await scope.issue.update(issue)
                }
            }
            for listedSubscriber in recipients {
                var subscriber = listedSubscriber
                if subscriber.unsubscribeToken == nil {
                    subscriber.ensureUnsubscribeToken()
                    let subscriberToUpdate = subscriber
                    subscriber = try await transaction.run { scope in
                        try await scope.subscriber.update(subscriberToUpdate)
                    }
                }
                guard let unsubscribeToken = subscriber.unsubscribeToken else {
                    continue
                }
                let subscriberEmail = subscriber.email
                let shouldEnqueue = try await transaction.run { context in
                    if var delivery = try await context.delivery.findBy(
                        issueId: input.issueId,
                        subscriberEmail: subscriberEmail
                    ) {
                        guard delivery.status == .failed else { return false }
                        delivery.status = .pending
                        delivery.sentDate = nil
                        delivery.failureReason = nil
                        _ = try await context.delivery.update(delivery)
                        return true
                    }
                    _ = try await context.delivery.insert(
                        .init(
                            issueId: input.issueId,
                            newsletterId: input.newsletterId,
                            subscriberEmail: subscriberEmail,
                            status: .pending,
                            sentDate: nil,
                            failureReason: nil
                        )
                    )
                    return true
                }
                guard shouldEnqueue else { continue }
                do {
                    try await jobs.enqueueIssue(
                        mail: .init(
                            from: .init(newsletter.fromEmail),
                            to: [.init(subscriberEmail)],
                            subject: input.subject,
                            body: .html(input.content)
                        ),
                        issueId: input.issueId,
                        newsletterId: input.newsletterId,
                        newsletterKey: newsletter.key,
                        unsubscribeToken: unsubscribeToken,
                        scheduledAt: input.scheduledDate
                    )
                }
                catch {
                    let failureReason = String(describing: error)
                    try? await transaction.run { scope in
                        guard
                            var delivery = try await scope.delivery.findBy(
                                issueId: input.issueId,
                                subscriberEmail: subscriberEmail
                            )
                        else {
                            return
                        }
                        delivery.status = .failed
                        delivery.failureReason = failureReason
                        _ = try await scope.delivery.update(delivery)
                    }
                    try? await markIssueFailedIfDeliveriesFinished(
                        issueId: input.issueId
                    )
                    throw error
                }
            }
        }

        private func markIssueFailedIfDeliveriesFinished(
            issueId: String
        ) async throws {
            try await transaction.run { scope in
                let deliveries = try await scope.delivery.list(
                    issueId: issueId
                )
                guard
                    !deliveries.isEmpty,
                    deliveries.allSatisfy({ $0.status != .pending }),
                    var issue = try await scope.issue.findBy(id: issueId)
                else {
                    return
                }
                issue.status = .failed
                issue.sentDate = nil
                _ = try await scope.issue.update(issue)
            }
        }

    }
}
