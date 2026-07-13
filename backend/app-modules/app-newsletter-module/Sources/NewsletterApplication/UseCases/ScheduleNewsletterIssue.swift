import Application
import NewsletterDomain
import struct Foundation.Date

public struct ScheduleNewsletterIssue: UseCase {
    struct Error: UseCaseError {
        let message: String
    }

    let transaction: any TransactionExecutor<WriteNewsletter>
    let clock: any Clock

    public init(
        transaction: any TransactionExecutor<WriteNewsletter>,
        clock: any Clock
    ) {
        self.transaction = transaction
        self.clock = clock
    }

    public struct Input: DTO {
        public let id: String
        public let scheduledDate: Date

        public init(
            id: String,
            scheduledDate: Date
        ) {
            self.id = id
            self.scheduledDate = scheduledDate
        }
    }

    public func execute(
        _ input: Input
    ) async throws -> NewsletterIssueDetail {
        let now = Date(timeIntervalSince1970: clock.now())
        return try await transaction.run { context in
            guard var model = try await context.issue.findBy(id: input.id) else {
                throw Error(message: "Newsletter issue not found")
            }

            try model.schedule(at: input.scheduledDate, now: now)
            return (try await context.issue.update(model)).asDetail
        }
    }
}
