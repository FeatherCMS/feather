import AdminOpenAPI
import BlogApplication
import Application
import Foundation

extension AdminAPI {

    func blogPostPatch(
        _ input: Operations.BlogPostPatch.Input
    ) async throws -> Operations.BlogPostPatch.Output {
        let body: Components.Schemas.BlogPostPatchSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.blog.makeEditPost()
        let subject = try await CurrentSubject.require()
        let metadata: BlogMetadataInput?
        if let metadataPatch = body.metadata {
            let current = try await modules.blog.makeGetPost()
                .execute(
                    subject: subject,
                    input: .init(id: input.path.blogPostId)
                )
            metadata = mergeBlogMetadata(
                metadataPatch,
                into: map(current.metadata)
            )
        }
        else {
            metadata = nil
        }
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
                metadata: metadata
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
