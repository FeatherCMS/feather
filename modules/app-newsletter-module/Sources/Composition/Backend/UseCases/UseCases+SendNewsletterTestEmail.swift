import NewsletterApplication

extension UseCases {

    func makeSendNewsletterTestEmail() -> SendTestEmail {
        .init(
            authorizer: authorizer,
            transaction: transaction(),
            jobs: jobs
        )
    }
}
