import AdminOpenAPI
import WebApplication
import Application

extension AdminAPI {

    func webPageCreate(
        _ input: Operations.WebPageCreate.Input
    ) async throws -> Operations.WebPageCreate.Output {
        let body: Components.Schemas.WebPageCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.web.makeAddPage()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                title: body.title,
                excerpt: body.excerpt,
                content: body.content,
                imageAssetId: body.imageAssetId,
                metadata: mapPageMetadata(body.metadata)
            )
        )

        return .created(.init(body: .json(map(result))))
    }
}
