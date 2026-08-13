import FeatherApplication
import FeatherContracts
import NewsletterAdminAPI
import NewsletterApplication

extension NewsletterBackend {
    public func newsletterIssueDelete(
        _ input: Operations.NewsletterIssueDelete.Input
    ) async throws -> Operations.NewsletterIssueDelete.Output {
        let subject = try await CurrentSubject.require()
        try await self.makeDeleteNewsletterIssue()
            .execute(
                subject: subject,
                input: .init(id: input.path.newsletterIssueId)
            )
        return .noContent
    }
}
