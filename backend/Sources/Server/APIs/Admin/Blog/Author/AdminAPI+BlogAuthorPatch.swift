import AdminOpenAPI
import BlogApplication
import Application
import Foundation

extension AdminAPI {

    func blogAuthorPatch(
        _ input: Operations.BlogAuthorPatch.Input
    ) async throws -> Operations.BlogAuthorPatch.Output {
        let body: Components.Schemas.BlogAuthorPatchSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.blog.makeEditAuthor()
        let subject = try await CurrentSubject.require()
        let metadata: BlogMetadataInput?
        if let metadataPatch = body.metadata {
            let current = try await modules.blog.makeGetAuthor()
                .execute(
                    subject: subject,
                    input: .init(id: input.path.blogAuthorId)
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
                id: input.path.blogAuthorId,
                name: body.name,
                excerpt: body.excerpt,
                content: body.content,
                profileImageAssetId: body.profileImageAssetId.map(
                    Optional.some
                ),
                metadata: metadata
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
