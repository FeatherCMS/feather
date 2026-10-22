public import BlogAdminAPI
import BlogApplication
import FeatherBackend
import FeatherDomain
import FeatherModuleKit

extension AdminAPIGateway {

    private enum UpdateMaskFields: String, Sendable {
        case name
        case excerpt
        case content
        case profileImageAssetId
    }

    public func blogAuthorPatch(
        _ input: Operations.BlogAuthorPatch.Input
    ) async throws -> Operations.BlogAuthorPatch.Output {
        let body: Components.Schemas.BlogAuthorPatchSchema
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
            let name = requiredFieldChange(
                value: body.name,
                shouldApply: fields.contains(.name)
            )
        else {
            return .badRequest(
                .init(
                    body: .json(
                        badRequestErrorEnvelope(
                            reason: "Missing selected field: name"
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
        let profileImageAssetId = OptionalFieldChange(
            value: body.profileImageAssetId ?? nil,
            shouldApply: fields.contains(.profileImageAssetId)
        )

        let useCase = self.useCases.makeEditAuthor()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.blogAuthorId,
                name: name,
                excerpt: excerpt,
                content: content,
                profileImageAssetId: profileImageAssetId,
                metadata: nil
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
