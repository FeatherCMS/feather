import FeatherApplication
import FeatherContracts
import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func webPageCreate(
        _ input: Operations.WebPageCreate.Input
    ) async throws -> Operations.WebPageCreate.Output {
        let body: Components.Schemas.WebPageCreateSchema
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
                metadata: useCases.defaultPageMetadata(
                    title: body.title,
                    excerpt: body.excerpt
                )
            )
        )

        return .created(.init(body: .json(useCases.map(result))))
    }
}
