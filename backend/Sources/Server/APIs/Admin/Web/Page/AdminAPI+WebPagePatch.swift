import AdminOpenAPI
import WebApplication
import Application
import Foundation

extension AdminAPI {

    func webPagePatch(
        _ input: Operations.WebPagePatch.Input
    ) async throws -> Operations.WebPagePatch.Output {
        let body: Components.Schemas.WebPagePatchSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.web.makeEditPage()
        let subject = try await CurrentSubject.require()
        let metadata: PageMetadataInput?
        if let metadataPatch = body.metadata {
            let current = try await modules.web.makeGetPage()
                .execute(
                    subject: subject,
                    input: .init(id: input.path.webPageId)
                )
            metadata = mergePageMetadata(
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
                id: input.path.webPageId,
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
