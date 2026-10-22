import FeatherModuleKit
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

        let useCase = useCases.makeEditPage()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.pageId,
                title: body.title,
                excerpt: body.excerpt,
                content: body.content,
                imageAssetId: body.imageAssetId,
                metadata: nil
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
