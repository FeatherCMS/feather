import NewsletterApplication

extension UseCases {

    func makeRemoveNewsletterCampaign() -> RemoveCampaign {
        .init(authorizer: authorizer, transaction: transaction())
    }
}
