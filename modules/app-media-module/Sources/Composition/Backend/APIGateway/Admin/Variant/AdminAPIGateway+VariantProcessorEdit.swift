import FeatherBackend
import FeatherDomain
import FeatherModuleKit
import Foundation
import Hummingbird
public import MediaAdminAPI
import MediaApplication
import MediaModule

extension AdminAPIGateway {
    private enum UpdateMaskFields: String, Sendable {
        case name
        case matchExtensions
        case commandTemplate
        case isActive
    }

    public func mediaVariantProcessorPatch(
        _ input: Operations.MediaVariantProcessorPatch.Input
    ) async throws -> Operations.MediaVariantProcessorPatch.Output {
        let body: Components.Schemas.MediaVariantProcessorPatchSchema
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
        let name = try FieldChange(
            value: body.name,
            shouldApply: fields.contains(.name),
            onMissing: { HTTPError(.badRequest) }
        )
        let matchExtensions = try FieldChange(
            value: body.matchExtensions,
            shouldApply: fields.contains(.matchExtensions),
            onMissing: { HTTPError(.badRequest) }
        )
        let commandTemplate = try FieldChange(
            value: body.commandTemplate,
            shouldApply: fields.contains(.commandTemplate),
            onMissing: { HTTPError(.badRequest) }
        )
        let isActive = try FieldChange(
            value: body.isActive,
            shouldApply: fields.contains(.isActive),
            onMissing: { HTTPError(.badRequest) }
        )
        let subject = try await CurrentSubject.require()
        do {
            let result = try await useCases.makeEditVariantProcessor()
                .execute(
                    subject: subject,
                    input: .init(
                        variantId: input.path.mediaVariantId,
                        id: input.path.mediaVariantProcessorId,
                        name: name,
                        matchExtensions: matchExtensions,
                        commandTemplate: commandTemplate,
                        isActive: isActive
                    )
                )
            return .ok(
                .init(
                    body: .json(
                        .init(
                            id: result.id,
                            variantId: result.variantId,
                            name: result.name,
                            matchExtensions: result.matchExtensions,
                            commandTemplate: result.commandTemplate,
                            isActive: result.isActive,
                            createdAt: result.createdAt.timeIntervalSince1970,
                            updatedAt: result.updatedAt.timeIntervalSince1970
                        )
                    )
                )
            )
        }
        catch Variant.Processor.Edit.Error.notFound {
            return .notFound(
                .init(
                    body: .json(
                        .init(
                            error: .init(
                                message: "Media variant processor not found.",
                                reason: "media_variant_processor_not_found"
                            )
                        )
                    )
                )
            )
        }
    }
}
