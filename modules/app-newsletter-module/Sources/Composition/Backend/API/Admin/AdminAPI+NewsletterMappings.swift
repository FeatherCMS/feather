import Foundation
import NewsletterAdminAPI
import NewsletterApplication
import NewsletterDomain

extension NewsletterBackend {

    private func timestamp(_ date: Date) -> Double {
        date.timeIntervalSince1970
    }
    func map(
        _ value: CampaignDetail
    ) -> Components.Schemas.NewsletterCampaignSchema {
        .init(
            id: value.id,
            name: value.name,
            fromEmail: value.fromEmail,
            createdAt: timestamp(value.createdAt),
            updatedAt: timestamp(value.updatedAt)
        )
    }

    func map(
        _ value: IssueDetail
    ) -> Components.Schemas.NewsletterIssueSchema {
        .init(
            id: value.id,
            newsletterId: value.newsletterId,
            subject: value.subject,
            content: value.content,
            status: value.status.rawValue,
            scheduledAt: value.scheduledDate.map(timestamp),
            sentAt: value.sentDate.map(timestamp),
            createdAt: timestamp(value.createdAt),
            updatedAt: timestamp(value.updatedAt)
        )
    }

    func map(
        _ value: SubscriberDetail
    ) -> Components.Schemas.NewsletterSubscriberSchema {
        .init(
            id: subscriberID(value.email),
            newsletterId: value.newsletterId,
            email: value.email,
            status: value.status.rawValue,
            subscriptionDate: timestamp(value.subscriptionDate),
            unsubscriptionDate: value.unsubscriptionDate.map(timestamp),
            firstName: value.firstName.isEmpty ? nil : value.firstName,
            lastName: value.lastName.isEmpty ? nil : value.lastName,
            createdAt: timestamp(value.createdAt),
            updatedAt: timestamp(value.updatedAt)
        )
    }

    func map(
        _ value: DeliveryDetail
    ) -> Components.Schemas.NewsletterDeliverySchema {
        .init(
            subscriberEmail: value.subscriberEmail,
            status: value.status.rawValue,
            sentAt: value.sentDate.map(timestamp),
            failureReason: value.failureReason,
            createdAt: timestamp(value.createdAt),
            updatedAt: timestamp(value.updatedAt)
        )
    }

    private func subscriberID(_ email: String) -> String {
        Data(email.utf8)
            .base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
