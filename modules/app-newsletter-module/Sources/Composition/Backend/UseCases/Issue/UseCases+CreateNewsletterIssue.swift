import NewsletterApplication

extension UseCases {

    func makeCreateNewsletterIssue() -> CreateIssue {
        .init(
            authorizer: authorizer,
            transaction: transaction()
        )
    }
}
