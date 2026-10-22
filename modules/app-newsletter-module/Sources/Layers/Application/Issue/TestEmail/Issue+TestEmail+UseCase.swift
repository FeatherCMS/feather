public import FeatherApplication
import FeatherMail
public import FeatherModuleKit
import NewsletterDomain
import NewsletterModule

extension Issue.TestEmail {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Issue.TestEmail.Scope>
        let jobs: any NewsletterIssueJobController

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Issue.TestEmail.Scope>,
            jobs: any NewsletterIssueJobController
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
            self.jobs = jobs
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
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

    }
}
