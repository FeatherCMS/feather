import NewsletterContracts
import FeatherApplication
import FeatherContracts
import NewsletterAdminAPI
import NewsletterApplication

extension AdminAPIGateway {
    public func newsletterCampaignTestEmail(
        _ input: Operations.NewsletterCampaignTestEmail.Input
    ) async throws -> Operations.NewsletterCampaignTestEmail.Output {
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
        try await useCases.enqueueIssueTestEmail(
            newsletterId: input.path.newsletterCampaignId,
            email: body.email,
            subject: body.subject,
            content: body.content
        )
        return .noContent
    }
}
