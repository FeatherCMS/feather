public import BlogAdminAPI
import BlogApplication
import BlogModule
import FeatherModuleKit
import Foundation
import WebApplication
import WebDomain
import WebModule

extension AdminAPIGateway {

    public func blogAuthorPost(
        _ input: Operations.BlogAuthorPost.Input
    ) async throws -> Operations.BlogAuthorPost.Output {
        let body: Components.Schemas.AuthorPostSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeAddAuthor()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                name: body.name,
                excerpt: body.excerpt ?? "",
                content: body.content ?? "",
                profileImageAssetId: body.profileImageAssetId,
                metadata: defaultAuthorMetadata(
                    title: body.name,
                    excerpt: body.excerpt ?? ""
                )
            )
        )

        return .created(.init(body: .json(mapAddedAuthor(result))))
    }

    private func mapAddedAuthor(
        _ detail: Author.Add.Output
    ) -> Components.Schemas.AuthorGetSchema {
        .init(
            id: detail.id,
            name: detail.name,
            excerpt: detail.excerpt,
            content: detail.content,
            profileImageAssetId: detail.profileImageAssetId,
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

    private func defaultAuthorMetadata(
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
