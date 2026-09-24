import NewsletterApplication

extension UseCases {

    func makeListNewsletterDeliveries() -> ListDeliveries {
        .init(authorizer: authorizer, transaction: transaction())
    }
}
