import NewsletterDomain

extension Issue {
    var asDetail: IssueDetail {
        .init(
            id: id,
            newsletterId: newsletterId,
            subject: subject,
            previewText: previewText,
            content: content,
            status: status,
            scheduledDate: scheduledDate,
            sentDate: sentDate,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
