import FeatherBackend
import FeatherDomain
import FeatherModuleKit
public import NewsletterAdminAPI
import NewsletterApplication
import NewsletterDomain
import NewsletterModule
import Hummingbird

extension AdminAPIGateway {
    private enum UpdateMaskFields: String, Sendable {
        case firstName
        case lastName
        case status
    }

    public func newsletterSubscriberUpdate(
        _ input: Operations.NewsletterSubscriberUpdate.Input
    ) async throws -> Operations.NewsletterSubscriberUpdate.Output {
        let subject = try await CurrentSubject.require()
        let body: Components.Schemas.NewsletterSubscriberPatchSchema
        switch input.body {
        case .json(let value): body = value
        }
        let fields: UpdateMask<UpdateMaskFields>
        do {
            fields = try .init(input.query.updateMask)
        }
        catch {
            throw HTTPError(.badRequest)
        }
        let result =
            try await useCases
            .makeEditNewsletterSubscriber()
            .execute(
                subject: subject,
                input: .init(
                    campaignKey: input.path.newsletterCampaignKey,
                    email: input.path.email,
                    firstName: try FieldChange(
                        value: body.firstName,
                        shouldApply: fields.contains(.firstName),
                        onMissing: { HTTPError(.badRequest) }
                    ),
                    lastName: try FieldChange(
                        value: body.lastName,
                        shouldApply: fields.contains(.lastName),
                        onMissing: { HTTPError(.badRequest) }
                    ),
                    status: try FieldChange(
                        value: body.status.flatMap(
                            Subscriber.Model.Status.init(rawValue:)
                        ),
                        shouldApply: fields.contains(.status),
                        onMissing: { HTTPError(.badRequest) }
                    )
                )
            )
        return .ok(
            .init(
                body: .json(
                    map(result, campaignKey: input.path.newsletterCampaignKey)
                )
            )
        )
    }
}
