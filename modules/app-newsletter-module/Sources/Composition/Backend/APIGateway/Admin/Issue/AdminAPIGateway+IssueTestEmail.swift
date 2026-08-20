import FeatherApplication
import FeatherContracts
import NewsletterAdminAPI
import NewsletterApplication

extension AdminAPIGateway {
    public func newsletterIssueTestEmail(
        _ input: Operations.NewsletterIssueTestEmail.Input
    ) async throws -> Operations.NewsletterIssueTestEmail.Output {
        let subject = try await CurrentSubject.require()
        struct Action: PermissionAction {
            let key = Permissions.Issues.update
        }
        let action = Action()
        guard
            try await useCases.authorizer.can(subject: subject, perform: action)
        else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        let body: Components.Schemas.NewsletterIssueTestEmailSchema
        switch input.body {
        case .json(let value): body = value
        }
        let issue = try await self.useCases.makeGetNewsletterIssue()
            .execute(
                subject: subject,
                input: .init(id: input.path.newsletterIssueId)
            )
        try await useCases.enqueueIssueTestEmail(
            issue: issue,
            email: body.email
        )
        return .noContent
    }
}
