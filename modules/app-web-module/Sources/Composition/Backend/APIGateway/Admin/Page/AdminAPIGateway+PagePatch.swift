import FeatherBackend
import FeatherDomain
import FeatherModuleKit
import Hummingbird
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    private enum UpdateMaskFields: String, Sendable {
        case title
        case excerpt
        case content
        case imageAssetId
    }

    public func pagePatch(
        _ input: Operations.PagePatch.Input
    ) async throws -> Operations.PagePatch.Output {
        let body: Components.Schemas.PagePatchSchema
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

        let title = try FieldChange(
            value: body.title,
            shouldApply: fields.contains(.title),
            onMissing: { HTTPError(.badRequest) }
        )
        let excerpt = try FieldChange(
            value: body.excerpt,
            shouldApply: fields.contains(.excerpt),
            onMissing: { HTTPError(.badRequest) }
        )
        let content = try FieldChange(
            value: body.content,
            shouldApply: fields.contains(.content),
            onMissing: { HTTPError(.badRequest) }
        )
        let imageAssetId = OptionalFieldChange(
            value: body.imageAssetId,
            shouldApply: fields.contains(.imageAssetId)
        )

        let useCase = useCases.makeEditPage()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.pageId,
                title: title,
                excerpt: excerpt,
                content: content,
                imageAssetId: imageAssetId,
                metadata: nil
            )
        )

        return .ok(.init(body: .json(mapEditedPage(result))))
    }
}
