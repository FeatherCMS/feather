import NewsletterApplication

extension UseCases {

    func makeSubscribeToNewsletter() -> Subscribe {
        .init(transaction: transaction())
    }
}
