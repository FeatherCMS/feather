import Foundation
import NewsletterAdminAPI
import NewsletterApplication
import NewsletterDomain
import NewsletterModule

extension AdminAPIGateway {

    private func timestamp(_ date: Date) -> Double {
        date.timeIntervalSince1970
    }
    func map(
        _ value: Campaign.Detail.Output
    ) -> Components.Schemas.NewsletterCampaignSchema {
        map(
            key: value.key,
            name: value.name,
            fromEmail: value.fromEmail,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt
        )
    }

    func map(
        _ value: Campaign.List.Output
    ) -> Components.Schemas.NewsletterCampaignSchema {
        map(
            key: value.key,
            name: value.name,
            fromEmail: value.fromEmail,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt
        )
    }

    func map(
        _ value: Campaign.Add.Output
    ) -> Components.Schemas.NewsletterCampaignSchema {
        map(
            key: value.key,
            name: value.name,
            fromEmail: value.fromEmail,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt
        )
    }

    func map(
        _ value: Campaign.Edit.Output
    ) -> Components.Schemas.NewsletterCampaignSchema {
        map(
            key: value.key,
            name: value.name,
            fromEmail: value.fromEmail,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt
        )
    }

    private func map(
        key: String,
        name: String,
        fromEmail: String,
        createdAt: Date,
        updatedAt: Date
    ) -> Components.Schemas.NewsletterCampaignSchema {
        .init(
            key: key,
            name: name,
            fromEmail: fromEmail,
            createdAt: timestamp(createdAt),
            updatedAt: timestamp(updatedAt)
        )
    }

    func map(
        _ value: Issue.Detail.Output,
        campaignKey: String
    ) -> Components.Schemas.NewsletterIssueSchema {
        map(
            id: value.id,
            subject: value.subject,
            content: value.content,
            status: value.status,
            scheduledDate: value.scheduledDate,
            sentDate: value.sentDate,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt,
            campaignKey: campaignKey
        )
    }

    func map(
        _ value: Issue.List.Output,
        campaignKey: String
    ) -> Components.Schemas.NewsletterIssueSchema {
        map(
            id: value.id,
            subject: value.subject,
            content: value.content,
            status: value.status,
            scheduledDate: value.scheduledDate,
            sentDate: value.sentDate,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt,
            campaignKey: campaignKey
        )
    }

    func map(
        _ value: Issue.Add.Output,
        campaignKey: String
    ) -> Components.Schemas.NewsletterIssueSchema {
        map(
            id: value.id,
            subject: value.subject,
            content: value.content,
            status: value.status,
            scheduledDate: value.scheduledDate,
            sentDate: value.sentDate,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt,
            campaignKey: campaignKey
        )
    }

    func map(
        _ value: Issue.Edit.Output,
        campaignKey: String
    ) -> Components.Schemas.NewsletterIssueSchema {
        map(
            id: value.id,
            subject: value.subject,
            content: value.content,
            status: value.status,
            scheduledDate: value.scheduledDate,
            sentDate: value.sentDate,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt,
            campaignKey: campaignKey
        )
    }

    func map(
        _ value: Issue.Schedule.Output,
        campaignKey: String
    ) -> Components.Schemas.NewsletterIssueSchema {
        map(
            id: value.id,
            subject: value.subject,
            content: value.content,
            status: value.status,
            scheduledDate: value.scheduledDate,
            sentDate: value.sentDate,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt,
            campaignKey: campaignKey
        )
    }

    private func map(
        id: String,
        subject: String,
        content: String,
        status: Issue.Model.Status,
        scheduledDate: Date?,
        sentDate: Date?,
        createdAt: Date,
        updatedAt: Date,
        campaignKey: String
    ) -> Components.Schemas.NewsletterIssueSchema {
        .init(
            id: id,
            campaignKey: campaignKey,
            subject: subject,
            content: content,
            status: status.rawValue,
            scheduledAt: scheduledDate.map(timestamp),
            sentAt: sentDate.map(timestamp),
            createdAt: timestamp(createdAt),
            updatedAt: timestamp(updatedAt)
        )
    }

    func map(
        _ value: Subscriber.Detail.Output,
        campaignKey: String
    ) -> Components.Schemas.NewsletterSubscriberSchema {
        map(
            email: value.email,
            status: value.status,
            subscriptionDate: value.subscriptionDate,
            unsubscriptionDate: value.unsubscriptionDate,
            firstName: value.firstName,
            lastName: value.lastName,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt,
            campaignKey: campaignKey
        )
    }

    func map(
        _ value: Subscriber.List.Output,
        campaignKey: String
    ) -> Components.Schemas.NewsletterSubscriberSchema {
        map(
            email: value.email,
            status: value.status,
            subscriptionDate: value.subscriptionDate,
            unsubscriptionDate: value.unsubscriptionDate,
            firstName: value.firstName,
            lastName: value.lastName,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt,
            campaignKey: campaignKey
        )
    }

    func map(
        _ value: Subscriber.Add.Output,
        campaignKey: String
    ) -> Components.Schemas.NewsletterSubscriberSchema {
        map(
            email: value.email,
            status: value.status,
            subscriptionDate: value.subscriptionDate,
            unsubscriptionDate: value.unsubscriptionDate,
            firstName: value.firstName,
            lastName: value.lastName,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt,
            campaignKey: campaignKey
        )
    }

    func map(
        _ value: Subscriber.Edit.Output,
        campaignKey: String
    ) -> Components.Schemas.NewsletterSubscriberSchema {
        map(
            email: value.email,
            status: value.status,
            subscriptionDate: value.subscriptionDate,
            unsubscriptionDate: value.unsubscriptionDate,
            firstName: value.firstName,
            lastName: value.lastName,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt,
            campaignKey: campaignKey
        )
    }

    func map(
        _ value: Subscriber.Subscribe.Output,
        campaignKey: String
    ) -> Components.Schemas.NewsletterSubscriberSchema {
        map(
            email: value.email,
            status: value.status,
            subscriptionDate: value.subscriptionDate,
            unsubscriptionDate: value.unsubscriptionDate,
            firstName: value.firstName,
            lastName: value.lastName,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt,
            campaignKey: campaignKey
        )
    }

    func map(
        _ value: Subscriber.Unsubscribe.Output,
        campaignKey: String
    ) -> Components.Schemas.NewsletterSubscriberSchema {
        map(
            email: value.email,
            status: value.status,
            subscriptionDate: value.subscriptionDate,
            unsubscriptionDate: value.unsubscriptionDate,
            firstName: value.firstName,
            lastName: value.lastName,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt,
            campaignKey: campaignKey
        )
    }

    private func map(
        email: String,
        status: Subscriber.Model.Status,
        subscriptionDate: Date,
        unsubscriptionDate: Date?,
        firstName: String,
        lastName: String,
        createdAt: Date,
        updatedAt: Date,
        campaignKey: String
    ) -> Components.Schemas.NewsletterSubscriberSchema {
        .init(
            id: subscriberID(email),
            campaignKey: campaignKey,
            email: email,
            status: status.rawValue,
            subscriptionDate: timestamp(subscriptionDate),
            unsubscriptionDate: unsubscriptionDate.map(timestamp),
            firstName: firstName.isEmpty ? nil : firstName,
            lastName: lastName.isEmpty ? nil : lastName,
            createdAt: timestamp(createdAt),
            updatedAt: timestamp(updatedAt)
        )
    }

    func map(
        _ value: Delivery.List.Output
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
