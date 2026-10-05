public import FeatherApplication
public import FeatherMail
public import Foundation

public protocol NewsletterIssueJobController: SendMailJobController {

    func enqueueIssue(
        mail: Mail,
        issueId: String,
        newsletterId: String,
        scheduledAt: Date?
    ) async throws

}
