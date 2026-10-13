import NewsletterApplication

extension UseCases {

    func makeRemoveNewsletterSubscriber() -> RemoveSubscriber {
        .init(authorizer: authorizer, transaction: transaction())
    }
}
