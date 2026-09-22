import NewsletterApplication

extension UseCases {

    func makeScheduleNewsletterIssue() -> ScheduleIssue {
        .init(
            authorizer: authorizer,
            transaction: transaction()
        )
    }
}
