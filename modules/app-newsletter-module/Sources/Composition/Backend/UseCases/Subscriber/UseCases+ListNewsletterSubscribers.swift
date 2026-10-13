import NewsletterApplication

extension UseCases {

    func makeListNewsletterSubscribers() -> ListSubscribers {
        .init(authorizer: authorizer, transaction: transaction())
    }
}
