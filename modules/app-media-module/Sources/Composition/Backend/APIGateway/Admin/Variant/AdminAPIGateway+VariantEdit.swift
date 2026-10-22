import FeatherBackend
import FeatherDomain
import FeatherModuleKit
import Hummingbird
public import MediaAdminAPI
import MediaApplication
import MediaModule

extension AdminAPIGateway {
    private enum UpdateMaskFields: String, Sendable {
        case key
        case name
        case isRequired
        case isActive
    }

    public func mediaVariantPatch(_ input: Operations.MediaVariantPatch.Input)
        async throws -> Operations.MediaVariantPatch.Output
    {
        let body: Components.Schemas.MediaVariantPatchSchema
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
        let key = try FieldChange(
            value: body.key,
            shouldApply: fields.contains(.key),
            onMissing: { HTTPError(.badRequest) }
        )
        let name = try FieldChange(
            value: body.name,
            shouldApply: fields.contains(.name),
            onMissing: { HTTPError(.badRequest) }
        )
        let isRequired = try FieldChange(
            value: body.isRequired,
            shouldApply: fields.contains(.isRequired),
            onMissing: { HTTPError(.badRequest) }
        )
        let isActive = try FieldChange(
            value: body.isActive,
            shouldApply: fields.contains(.isActive),
            onMissing: { HTTPError(.badRequest) }
        )
        let subject = try await CurrentSubject.require()
        do {
            let result = try await useCases.makeEditVariant()
                .execute(
                    subject: subject,
                    input: .init(
                        id: input.path.mediaVariantId,
                        key: key,
                        name: name,
                        isRequired: isRequired,
                        isActive: isActive
                    )
                )
            return .ok(.init(body: .json(map(result.detail))))
        }
        catch Variant.Edit.Error.notFound {
            return .notFound(
                .init(
                    body: .json(
                        errorEnvelope(
                            message: "Media variant not found.",
                            reason: "media_variant_not_found"
                        )
                    )
                )
            )
        }
    }
}
