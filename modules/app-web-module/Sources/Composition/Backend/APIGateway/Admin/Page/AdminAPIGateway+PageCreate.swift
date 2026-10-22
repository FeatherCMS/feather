import FeatherModuleKit
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func pageCreate(
        _ input: Operations.PageCreate.Input
    ) async throws -> Operations.PageCreate.Output {
        let body: Components.Schemas.PageCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = useCases.makeAddPage()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                title: body.title,
                excerpt: body.excerpt,
                content: body.content,
                imageAssetId: body.imageAssetId,
                metadata: defaultPageMetadata(
                    title: body.title,
                    excerpt: body.excerpt
                )
            )
        )

        return .created(.init(body: .json(map(result))))
    }
}
