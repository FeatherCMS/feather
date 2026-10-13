import NewsletterApplication

extension UseCases {

    func makeCreateNewsletterSubscriber() -> CreateSubscriber {
        .init(
            authorizer: authorizer,
            transaction: transaction()
        )
    }
}
