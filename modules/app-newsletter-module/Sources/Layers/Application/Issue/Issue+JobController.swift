public import FeatherApplication
public import FeatherMail
public import Foundation
public import NewsletterModule

extension Issue {
    public enum JobController {}
}

extension Issue.JobController {
    public protocol Interface: SendMailJobController {
        func enqueueIssue(
            mail: Mail,
            issueId: String,
            newsletterId: String,
            newsletterKey: String,
            unsubscribeToken: String,
            scheduledAt: Date?
        ) async throws
    }
}
