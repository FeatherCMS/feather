import BlogAdminAPI
import BlogApplication
import FeatherApplication
import FeatherContracts
import Foundation

extension AdminAPIGateway {

    public func blogTagPatch(
        _ input: Operations.BlogTagPatch.Input
    ) async throws -> Operations.BlogTagPatch.Output {
        let body: Components.Schemas.BlogTagPatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeEditTag()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.blogTagId,
                title: body.title,
                excerpt: body.excerpt,
                content: body.content,
                imageAssetId: body.imageAssetId.map(Optional.some),
                metadata: nil
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
