import NewsletterApplication

extension UseCases {

    func makeSendNewsletterIssueEmails() -> SendIssueEmails {
        .init(
            authorizer: authorizer,
            transaction: transaction(),
            jobs: jobs
        )
    }
}
