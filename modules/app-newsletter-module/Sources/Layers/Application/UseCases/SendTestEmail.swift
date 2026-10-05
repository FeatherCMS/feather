import NewsletterContracts
import NewsletterDomain
public import FeatherApplication
public import FeatherContracts
import FeatherMail

public struct SendTestEmail: UseCase {
    struct Action: PermissionAction {
        let key = Permissions.Issues.update
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<Write>
    let jobs: any NewsletterIssueJobController

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<Write>,
        jobs: any NewsletterIssueJobController
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.jobs = jobs
    }

    public struct Input: DTO {
        public let newsletterKey: String
        public let email: String
        public let subject: String
        public let content: String

        public init(
            newsletterKey: String,
            email: String,
            subject: String,
            content: String
        ) {
            self.newsletterKey = newsletterKey
            self.email = email
            self.subject = subject
            self.content = content
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let newsletter = try await transaction.run { scope in
            guard
                let newsletter = try await scope.newsletter.findBy(
                    key: input.newsletterKey
                )
            else {
                throw Error.newsletterNotFound
            }
            return newsletter
        }
        guard !newsletter.fromEmail.isEmpty else { return }

        try await jobs.enqueue(
            .init(
                from: .init(newsletter.fromEmail),
                to: [.init(input.email)],
                subject: input.subject,
                body: .html(input.content)
            )
        )
    }

    public enum Error: UseCaseError {
        case newsletterNotFound
    }
}
