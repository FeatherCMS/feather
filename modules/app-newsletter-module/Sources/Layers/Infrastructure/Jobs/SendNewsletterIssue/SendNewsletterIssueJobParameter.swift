public import FeatherInfrastructure
public import Jobs

public struct SendNewsletterIssueJobParameter: JobParameters {
    public static let jobName = "send_newsletter_issue_mail"

    public let mail: SendMailJobParameters
    public let issueId: String
    public let newsletterId: String
    public let newsletterKey: String?
    public let unsubscribeToken: String?

    public init(
        mail: SendMailJobParameters,
        issueId: String,
        newsletterId: String,
        newsletterKey: String? = nil,
        unsubscribeToken: String? = nil
    ) {
        self.mail = mail
        self.issueId = issueId
        self.newsletterId = newsletterId
        self.newsletterKey = newsletterKey
        self.unsubscribeToken = unsubscribeToken
    }
}
