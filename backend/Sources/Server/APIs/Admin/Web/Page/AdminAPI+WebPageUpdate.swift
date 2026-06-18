import AdminOpenAPI
import WebApplication
import Application

extension AdminAPI {

    func webPageUpdate(
        _ input: Operations.WebPageUpdate.Input
    ) async throws -> Operations.WebPageUpdate.Output {
        let body: Components.Schemas.WebPageCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.web.makeEditPage()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.webPageId,
                title: body.title,
                excerpt: body.excerpt,
                content: body.content,
                imageAssetId: .some(body.imageAssetId),
                metadata: mapPageMetadata(body.metadata)
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
