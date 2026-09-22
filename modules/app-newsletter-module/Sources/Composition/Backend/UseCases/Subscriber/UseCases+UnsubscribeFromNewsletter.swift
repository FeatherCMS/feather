import NewsletterApplication

extension UseCases {

    func makeUnsubscribeFromNewsletter() -> Unsubscribe {
        .init(transaction: transaction())
    }
}
