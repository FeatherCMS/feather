import FeatherApplication
import FeatherContracts
import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func webPageUpdate(
        _ input: Operations.WebPageUpdate.Input
    ) async throws -> Operations.WebPageUpdate.Output {
        let body: Components.Schemas.WebPagePatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = useCases.makeEditPage()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.webPageId,
                title: body.title,
                excerpt: body.excerpt,
                content: body.content,
                imageAssetId: body.imageAssetId,
                metadata: nil
            )
        )

        return .ok(.init(body: .json(useCases.map(result))))
    }
}
