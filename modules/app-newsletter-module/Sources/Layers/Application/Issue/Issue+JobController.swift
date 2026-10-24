import Foundation
public import FeatherMail
import NewsletterModule

extension Issue {
    public enum JobController {}
}

extension Issue.JobController {
    public protocol Interface: SendMailJobController {
        func enqueueIssue(
            mail: Mail,
            issueId: String,
            newsletterId: String,
            scheduledAt: Date?
        ) async throws
    }
}
