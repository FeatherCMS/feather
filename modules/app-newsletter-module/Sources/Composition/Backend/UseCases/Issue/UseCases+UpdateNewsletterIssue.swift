import NewsletterApplication

extension UseCases {

    func makeUpdateNewsletterIssue() -> UpdateIssue {
        .init(authorizer: authorizer, transaction: transaction())
    }
}
