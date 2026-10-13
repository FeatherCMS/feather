import NewsletterApplication

extension UseCases {

    func makeListNewsletterIssues() -> ListIssues {
        .init(authorizer: authorizer, transaction: transaction())
    }
}
