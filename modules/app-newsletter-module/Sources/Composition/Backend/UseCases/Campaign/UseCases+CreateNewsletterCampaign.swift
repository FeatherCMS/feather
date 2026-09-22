import NewsletterApplication

extension UseCases {

    func makeCreateNewsletterCampaign() -> CreateCampaign {
        .init(
            authorizer: authorizer,
            transaction: transaction()
        )
    }
}
