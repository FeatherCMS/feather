import BlogAdminAPI
import BlogApplication
import FeatherApplication
import FeatherContracts
import Foundation

extension BlogBackend {

    public func blogPostPatch(
        _ input: Operations.BlogPostPatch.Input
    ) async throws -> Operations.BlogPostPatch.Output {
        let body: Components.Schemas.BlogPostPatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.makeEditPost()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.blogPostId,
                title: body.title,
                excerpt: body.excerpt,
                content: body.content,
                imageAssetId: body.imageAssetId.map(Optional.some),
                authorIds: body.authorIds.map(Array.init),
                tagIds: body.tagIds.map(Array.init),
                metadata: nil
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
