import NewsletterApplication

extension UseCases {

    func makeGetNewsletterSubscriber() -> GetSubscriber {
        .init(authorizer: authorizer, transaction: transaction())
    }
}
