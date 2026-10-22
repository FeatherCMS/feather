public import BlogAdminAPI
import BlogApplication
import FeatherBackend
import FeatherDomain
import FeatherModuleKit

extension AdminAPIGateway {

    private enum UpdateMaskFields: String, Sendable {
        case title
        case excerpt
        case content
        case imageAssetId
    }

    public func blogTagPatch(
        _ input: Operations.BlogTagPatch.Input
    ) async throws -> Operations.BlogTagPatch.Output {
        let body: Components.Schemas.TagPatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let fields: UpdateMask<UpdateMaskFields>
        do {
            fields = try .init(input.query.updateMask)
        }
        catch {
            return .badRequest(
                .init(
                    body: .json(
                        badRequestErrorEnvelope(reason: "Invalid updateMask")
                    )
                )
            )
        }

        guard
            let title = requiredFieldChange(
                value: body.title,
                shouldApply: fields.contains(.title)
            )
        else {
            return .badRequest(
                .init(
                    body: .json(
                        badRequestErrorEnvelope(
                            reason: "Missing selected field: title"
                        )
                    )
                )
            )
        }
        guard
            let excerpt = requiredFieldChange(
                value: body.excerpt,
                shouldApply: fields.contains(.excerpt)
            )
        else {
            return .badRequest(
                .init(
                    body: .json(
                        badRequestErrorEnvelope(
                            reason: "Missing selected field: excerpt"
                        )
                    )
                )
            )
        }
        guard
            let content = requiredFieldChange(
                value: body.content,
                shouldApply: fields.contains(.content)
            )
        else {
            return .badRequest(
                .init(
                    body: .json(
                        badRequestErrorEnvelope(
                            reason: "Missing selected field: content"
                        )
                    )
                )
            )
        }
        let imageAssetId = OptionalFieldChange(
            value: body.imageAssetId ?? nil,
            shouldApply: fields.contains(.imageAssetId)
        )

        let useCase = self.useCases.makeEditTag()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.blogTagId,
                title: title,
                excerpt: excerpt,
                content: content,
                imageAssetId: imageAssetId,
                metadata: nil
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
