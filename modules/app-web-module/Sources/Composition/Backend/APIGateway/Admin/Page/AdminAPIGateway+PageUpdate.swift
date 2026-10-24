import FeatherDomain
import FeatherModuleKit
import Hummingbird
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func pageUpdate(
        _ input: Operations.PageUpdate.Input
    ) async throws -> Operations.PageUpdate.Output {
        let body: Components.Schemas.PagePatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let title = try FieldChange(
            value: body.title,
            shouldApply: true,
            onMissing: { HTTPError(.badRequest) }
        )
        let excerpt = try FieldChange(
            value: body.excerpt,
            shouldApply: true,
            onMissing: { HTTPError(.badRequest) }
        )
        let content = try FieldChange(
            value: body.content,
            shouldApply: true,
            onMissing: { HTTPError(.badRequest) }
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
                imageAssetId: .init(
                    value: body.imageAssetId,
                    shouldApply: true
                ),
                metadata: nil
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
