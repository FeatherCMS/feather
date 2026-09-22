import NewsletterApplication

extension UseCases {

    func makeGetNewsletterIssue() -> GetIssue {
        .init(authorizer: authorizer, transaction: transaction())
    }
}
