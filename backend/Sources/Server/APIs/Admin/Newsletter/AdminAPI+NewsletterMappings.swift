import AdminOpenAPI
import NewsletterApplication
import NewsletterDomain

extension AdminAPI {
    func map(
        _ value: NewsletterDetail
    ) -> Components.Schemas.ContactNewsletterSchema {
        .init(id: value.id, name: value.name, createdAt: timestamp(value.createdAt), updatedAt: timestamp(value.updatedAt))
    }

    func map(
        _ value: NewsletterIssueDetail
    ) -> Components.Schemas.ContactNewsletterIssueSchema {
        .init(id: value.id, newsletterId: value.newsletterId, subject: value.subject, content: value.content, status: value.status.rawValue, scheduledAt: value.scheduledDate.map(timestamp), sentAt: value.sentDate.map(timestamp), createdAt: timestamp(value.createdAt), updatedAt: timestamp(value.updatedAt))
    }

    func map(
        _ value: NewsletterSubscriberDetail
    ) -> Components.Schemas.ContactNewsletterSubscriberSchema {
        .init(id: value.email, newsletterId: value.newsletterId, email: value.email, status: value.status.rawValue, subscriptionDate: timestamp(value.subscriptionDate), unsubscriptionDate: value.unsubscriptionDate.map(timestamp), firstName: value.firstName.isEmpty ? nil : value.firstName, lastName: value.lastName.isEmpty ? nil : value.lastName, createdAt: timestamp(value.createdAt), updatedAt: timestamp(value.updatedAt))
    }
}
