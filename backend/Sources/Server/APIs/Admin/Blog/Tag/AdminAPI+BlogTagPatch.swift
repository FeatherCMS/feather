import AdminOpenAPI
import BlogApplication
import Application
import Foundation

extension AdminAPI {

    func blogTagPatch(
        _ input: Operations.BlogTagPatch.Input
    ) async throws -> Operations.BlogTagPatch.Output {
        let body: Components.Schemas.BlogTagPatchSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.blog.makeEditTag()
        let subject = try await CurrentSubject.require()
        let metadata: BlogMetadataInput?
        if let metadataPatch = body.metadata {
            let current = try await modules.blog.makeGetTag()
                .execute(
                    subject: subject,
                    input: .init(id: input.path.blogTagId)
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
                id: input.path.blogTagId,
                title: body.title,
                excerpt: body.excerpt,
                content: body.content,
                imageAssetId: body.imageAssetId.map(Optional.some),
                metadata: metadata
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
