import FeatherModuleKit
import Foundation
public import NewsletterAdminAPI
import NewsletterApplication
import NewsletterDomain
import NewsletterModule

extension AdminAPIGateway {
    public func newsletterSubscriberList(
        _ input: Operations.NewsletterSubscriberList.Input
    ) async throws -> Operations.NewsletterSubscriberList.Output {
        let subject = try await CurrentSubject.require()
        let campaignKey = try await campaignKey(
            for: input.path.newsletterCampaignId,
            subject: subject
        )
        let result =
            try await useCases
            .makeListSubscribers()
            .execute(
                subject: subject,
                input: .init(campaignKey: campaignKey)
            )
        return .ok(
            .init(
                body: .json(
                    result.items.map {
                        map(
                            $0,
                            campaignKey: campaignKey
                        )
                    }
                )
            )
        )
    }

    private func map(
        _ value: Subscriber.List.Item,
        campaignKey: String
    ) -> Components.Schemas.NewsletterSubscriberListItemSchema {
        .init(
            id: subscriberID(value.email),
            campaignKey: campaignKey,
            email: value.email,
            status: value.status.rawValue,
            subscriptionDate: value.subscriptionDate.timeIntervalSince1970,
            unsubscriptionDate: value.unsubscriptionDate?.timeIntervalSince1970,
            firstName: value.firstName.isEmpty ? nil : value.firstName,
            lastName: value.lastName.isEmpty ? nil : value.lastName,
            createdAt: value.createdAt.timeIntervalSince1970,
            updatedAt: value.updatedAt.timeIntervalSince1970
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
