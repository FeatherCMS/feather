import FeatherBackend
import FeatherDomain
import FeatherModuleKit
import Foundation
import Hummingbird
public import NewsletterAdminAPI
import NewsletterApplication
import NewsletterModule

extension AdminAPIGateway {
    private enum UpdateMaskFields: String, Sendable {
        case key
        case name
        case fromEmail
    }

    public func newsletterCampaignUpdate(
        _ input: Operations.NewsletterCampaignUpdate.Input
    ) async throws -> Operations.NewsletterCampaignUpdate.Output {
        let subject = try await CurrentSubject.require()
        let body: Components.Schemas.NewsletterCampaignPatchSchema
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
        let result = try await self.useCases.makeEditCampaign()
            .execute(
                subject: subject,
                input: .init(
                    key: input.path.newsletterCampaignKey,
                    newKey: try FieldChange(
                        value: body.key,
                        shouldApply: fields.contains(.key),
                        onMissing: { HTTPError(.badRequest) }
                    ),
                    name: try FieldChange(
                        value: body.name,
                        shouldApply: fields.contains(.name),
                        onMissing: { HTTPError(.badRequest) }
                    ),
                    fromEmail: try FieldChange(
                        value: body.fromEmail,
                        shouldApply: fields.contains(.fromEmail),
                        onMissing: { HTTPError(.badRequest) }
                    )
                )
            )
        return .ok(.init(body: .json(map(result))))
    }

    private func map(
        _ value: Campaign.Edit.Output
    ) -> Components.Schemas.NewsletterCampaignSchema {
        .init(
            key: value.key,
            name: value.name,
            fromEmail: value.fromEmail,
            createdAt: value.createdAt.timeIntervalSince1970,
            updatedAt: value.updatedAt.timeIntervalSince1970
        )
    }
}
