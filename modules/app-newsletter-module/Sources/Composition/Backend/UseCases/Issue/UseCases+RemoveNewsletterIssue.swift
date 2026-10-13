import NewsletterApplication

extension UseCases {

    func makeRemoveNewsletterIssue() -> RemoveIssue {
        .init(authorizer: authorizer, transaction: transaction())
    }
}
