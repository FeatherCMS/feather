import FeatherBackend
import FeatherDomain
import FeatherModuleKit
import Hummingbird
public import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    private enum UpdateMaskFields: String, Sendable {
        case title
        case altText
    }

    public func mediaAssetPatch(
        _ input: Operations.MediaAssetPatch.Input
    ) async throws -> Operations.MediaAssetPatch.Output {
        let body: Components.Schemas.MediaAssetPatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let fields: UpdateMask<UpdateMaskFields>
        do {
            fields = try .init(input.query.updateMask)
        }
        catch {
            throw HTTPError(.badRequest)
        }

        let subject = try await CurrentSubject.require()
        let result = try await self.useCases.makeEditAsset()
            .execute(
                subject: subject,
                input: .init(
                    id: input.path.mediaAssetId,
                    title: OptionalFieldChange(
                        value: body.title,
                        shouldApply: fields.contains(.title)
                    ),
                    altText: OptionalFieldChange(
                        value: body.altText,
                        shouldApply: fields.contains(.altText)
                    )
                )
            )

        return .ok(.init(body: .json(map(result.detail))))
    }
}
