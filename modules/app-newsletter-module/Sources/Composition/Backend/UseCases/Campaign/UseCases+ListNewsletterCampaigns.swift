import NewsletterApplication

extension UseCases {

    func makeListNewsletterCampaigns() -> ListCampaigns {
        .init(authorizer: authorizer, transaction: transaction())
    }
}
