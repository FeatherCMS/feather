import FeatherApplication
import FeatherContracts
import Foundation
import NewsletterAdminAPI
import NewsletterApplication
import NewsletterDomain

extension NewsletterBackend {
    public func newsletterIssueUpdate(
        _ input: Operations.NewsletterIssueUpdate.Input
    ) async throws -> Operations.NewsletterIssueUpdate.Output {
        let subject = try await CurrentSubject.require()
        let body: Components.Schemas.NewsletterIssuePatchSchema
        switch input.body {
        case .json(let value): body = value
        }
        let current = try await self.makeGetNewsletterIssue()
            .execute(
                subject: subject,
                input: .init(id: input.path.newsletterIssueId)
            )
        let result = try await self.makeUpdateNewsletterIssue()
            .execute(
                subject: subject,
                input: .init(
                    id: current.id,
                    subject: body.subject ?? current.subject,
                    content: body.content ?? current.content,
                    scheduledDate: body.scheduledAt.map {
                        Date(timeIntervalSince1970: $0)
                    } ?? current.scheduledDate
                )
            )
        if result.scheduledDate == nil && result.status == .draft {
            try await self.enqueueIssueEmails(issue: result)
        }
        return .ok(.init(body: .json(map(result))))
    }
}
