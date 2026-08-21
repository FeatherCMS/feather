import FeatherApplication
import FeatherContracts
import NewsletterAdminAPI
import NewsletterApplication

extension AdminAPIGateway {
    public func newsletterIssueDelete(
        _ input: Operations.NewsletterIssueDelete.Input
    ) async throws -> Operations.NewsletterIssueDelete.Output {
        let subject = try await CurrentSubject.require()
        try await self.useCases.makeDeleteNewsletterIssue()
            .execute(
                subject: subject,
                input: .init(id: input.path.newsletterIssueId)
            )
        return .noContent
    }
}
