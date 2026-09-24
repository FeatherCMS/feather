import NewsletterApplication

extension UseCases {

    func makeGetNewsletterCampaign() -> GetCampaign {
        .init(authorizer: authorizer, transaction: transaction())
    }
}
