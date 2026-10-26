public import BlogAdminAPI
import BlogApplication
import BlogModule
import FeatherModuleKit
import Foundation
import WebApplication
import WebDomain
import WebModule

extension AdminAPIGateway {

    public func blogPostPost(
        _ input: Operations.BlogPostPost.Input
    ) async throws -> Operations.BlogPostPost.Output {
        let body: Components.Schemas.PostPostSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeAddPost()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                title: body.title,
                excerpt: body.excerpt,
                content: body.content,
                imageAssetId: body.imageAssetId,
                authorIds: Array(body.authorIds ?? []),
                tagIds: Array(body.tagIds ?? []),
                metadata: defaultPostMetadata(
                    title: body.title,
                    excerpt: body.excerpt
                )
            )
        )

        return .created(.init(body: .json(mapAddedPost(result))))
    }

    private func mapAddedPost(
        _ detail: Post.Add.Output
    ) -> Components.Schemas.PostGetSchema {
        .init(
            id: detail.id,
            title: detail.title,
            excerpt: detail.excerpt,
            content: detail.content,
            imageAssetId: detail.imageAssetId,
            authorIds: detail.authorIds,
            tagIds: detail.tagIds,
            metadata: .init(
                id: detail.metadata.id,
                referenceType: detail.metadata.referenceType,
                referenceId: detail.metadata.referenceID,
                slug: detail.metadata.slug,
                template: detail.metadata.template,
                publicationDate: detail.metadata.publicationDate
                    .timeIntervalSince1970,
                expirationDate: detail.metadata.expirationDate?
                    .timeIntervalSince1970,
                status: detail.metadata.status.rawValue,
                title: detail.metadata.title,
                excerpt: detail.metadata.excerpt,
                imageUrl: detail.metadata.imageURL,
                canonicalUrl: detail.metadata.canonicalURL,
                noIndex: detail.metadata.noIndex,
                primaryKeyword: detail.metadata.primaryKeyword ?? "",
                cssCodeInjection: detail.metadata.cssCodeInjection,
                javascriptCodeInjection: detail.metadata
                    .javascriptCodeInjection,
                structuredDataCodeInjection: detail.metadata
                    .structuredDataCodeInjection,
                createdAt: detail.metadata.createdAt.timeIntervalSince1970,
                updatedAt: detail.metadata.updatedAt.timeIntervalSince1970
            ),
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }

    private func defaultPostMetadata(
        title: String,
        excerpt: String
    ) -> WebModule.Metadata.Model.Base {
        .init(
            template: "default",
            slug: title.slugified,
            publicationDate: .init(),
            expirationDate: nil,
            status: .draft,
            title: title,
            excerpt: excerpt,
            imageURL: nil,
            canonicalURL: "",
            noIndex: false,
            primaryKeyword: nil,
            cssCodeInjection: "",
            javascriptCodeInjection: "",
            structuredDataCodeInjection: ""
        )
    }
}
