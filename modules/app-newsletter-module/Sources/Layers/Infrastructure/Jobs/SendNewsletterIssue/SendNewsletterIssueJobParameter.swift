public import FeatherInfrastructure
public import Jobs

public struct SendNewsletterIssueJobParameter: JobParameters {
    public static let jobName = "send_newsletter_issue_mail"

    public let mail: SendMailJobParameters
    public let issueId: String
    public let newsletterId: String

    public init(
        mail: SendMailJobParameters,
        issueId: String,
        newsletterId: String
    ) {
        self.mail = mail
        self.issueId = issueId
        self.newsletterId = newsletterId
    }
}
