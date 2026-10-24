public import BlogAdminAPI
import BlogApplication
import BlogModule
import FeatherModuleKit
import Foundation
import WebApplication
import WebDomain
import WebModule

extension AdminAPIGateway {

    public func blogTagPost(
        _ input: Operations.BlogTagPost.Input
    ) async throws -> Operations.BlogTagPost.Output {
        let body: Components.Schemas.TagPostSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeAddTag()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                title: body.title,
                excerpt: body.excerpt,
                content: body.content,
                imageAssetId: body.imageAssetId,
                metadata: .init(
                    slug: body.title.slugified,
                    template: "default",
                    publicationDate: nil,
                    expirationDate: nil,
                    status: .draft,
                    title: body.title,
                    excerpt: body.excerpt,
                    imageURL: nil,
                    canonicalURL: "",
                    noIndex: false,
                    primaryKeyword: "",
                    cssCodeInjection: "",
                    javascriptCodeInjection: "",
                    structuredDataCodeInjection: ""
                )
            )
        )

        return .created(.init(body: .json(mapTag(result))))
    }
}

extension AdminAPIGateway {
    private func mapTag(_ output: Tag.Add.Output)
        -> Components.Schemas.TagGetSchema
    {
        .init(
            id: output.id,
            title: output.title,
            excerpt: output.excerpt,
            content: output.content,
            imageAssetId: output.imageAssetId,
            metadata: .init(
                id: output.metadata.id,
                referenceType: output.metadata.referenceType,
                referenceId: output.metadata.referenceID,
                slug: output.metadata.slug,
                template: output.metadata.template,
                publicationDate: output.metadata.publicationDate
                    .timeIntervalSince1970,
                expirationDate: output.metadata.expirationDate?
                    .timeIntervalSince1970,
                status: output.metadata.status.rawValue,
                title: output.metadata.title,
                excerpt: output.metadata.excerpt,
                imageUrl: output.metadata.imageURL,
                canonicalUrl: output.metadata.canonicalURL,
                noIndex: output.metadata.noIndex,
                primaryKeyword: output.metadata.primaryKeyword ?? "",
                cssCodeInjection: output.metadata.cssCodeInjection,
                javascriptCodeInjection: output.metadata
                    .javascriptCodeInjection,
                structuredDataCodeInjection: output.metadata
                    .structuredDataCodeInjection,
                createdAt: output.metadata.createdAt.timeIntervalSince1970,
                updatedAt: output.metadata.updatedAt.timeIntervalSince1970
            ),
            createdAt: output.createdAt.timeIntervalSince1970,
            updatedAt: output.updatedAt.timeIntervalSince1970
        )
    }
}
