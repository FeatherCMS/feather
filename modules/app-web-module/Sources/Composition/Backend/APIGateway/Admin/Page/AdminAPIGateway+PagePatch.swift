import FeatherApplication
import FeatherContracts
import Foundation
import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func webPagePatch(
        _ input: Operations.WebPagePatch.Input
    ) async throws -> Operations.WebPagePatch.Output {
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
