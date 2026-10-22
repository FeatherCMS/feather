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
        case authorIds
        case tagIds
    }

    public func blogPostPatch(
        _ input: Operations.BlogPostPatch.Input
    ) async throws -> Operations.BlogPostPatch.Output {
        let body: Components.Schemas.BlogPostPatchSchema
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
        guard
            let authorIds = requiredFieldChange(
                value: body.authorIds.map(Array.init),
                shouldApply: fields.contains(.authorIds)
            )
        else {
            return .badRequest(
                .init(
                    body: .json(
                        badRequestErrorEnvelope(
                            reason: "Missing selected field: authorIds"
                        )
                    )
                )
            )
        }
        guard
            let tagIds = requiredFieldChange(
                value: body.tagIds.map(Array.init),
                shouldApply: fields.contains(.tagIds)
            )
        else {
            return .badRequest(
                .init(
                    body: .json(
                        badRequestErrorEnvelope(
                            reason: "Missing selected field: tagIds"
                        )
                    )
                )
            )
        }

        let useCase = self.useCases.makeEditPost()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.blogPostId,
                title: title,
                excerpt: excerpt,
                content: content,
                imageAssetId: imageAssetId,
                authorIds: authorIds,
                tagIds: tagIds,
                metadata: nil
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
