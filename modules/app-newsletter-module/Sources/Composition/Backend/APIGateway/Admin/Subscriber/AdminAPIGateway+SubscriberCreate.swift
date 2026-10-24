import FeatherModuleKit
import Foundation
public import NewsletterAdminAPI
import NewsletterApplication
import NewsletterDomain
import NewsletterModule

extension AdminAPIGateway {
    public func newsletterSubscriberCreate(
        _ input: Operations.NewsletterSubscriberCreate.Input
    ) async throws -> Operations.NewsletterSubscriberCreate.Output {
        let subject = try await CurrentSubject.require()
        let body: Components.Schemas.NewsletterSubscriberCreateSchema
        switch input.body {
        case .json(let value): body = value
        }
        let status =
            Subscriber.Model.Status(
                rawValue: body.status ?? "subscribed"
            ) ?? .subscribed
        let result =
            try await useCases
            .makeAddNewsletterSubscriber()
            .execute(
                subject: subject,
                input: .init(
                    campaignKey: input.path.newsletterCampaignKey,
                    email: body.email,
                    firstName: body.firstName ?? "",
                    lastName: body.lastName ?? "",
                    status: status
                )
            )
        return .created(
            .init(
                body: .json(
                    map(result, campaignKey: input.path.newsletterCampaignKey)
                )
            )
        )
    }

    private func map(
        _ value: Subscriber.Add.Output,
        campaignKey: String
    ) -> Components.Schemas.NewsletterSubscriberSchema {
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
