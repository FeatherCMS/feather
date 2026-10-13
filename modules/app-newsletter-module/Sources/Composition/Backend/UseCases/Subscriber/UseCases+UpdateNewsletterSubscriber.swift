import NewsletterApplication

extension UseCases {

    func makeUpdateNewsletterSubscriber() -> UpdateSubscriber {
        .init(
            authorizer: authorizer,
            transaction: transaction()
        )
    }
}
