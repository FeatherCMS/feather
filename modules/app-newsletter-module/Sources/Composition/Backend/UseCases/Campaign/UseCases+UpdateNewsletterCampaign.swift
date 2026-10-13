import NewsletterApplication

extension UseCases {

    func makeUpdateNewsletterCampaign() -> UpdateCampaign {
        .init(authorizer: authorizer, transaction: transaction())
    }
}
