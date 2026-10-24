public import BlogAdminAPI
import BlogApplication
import BlogModule
import FeatherModuleKit
import Foundation
import WebModule
import WebApplication
import WebDomain

extension AdminAPIGateway {

    public func blogPostGet(
        _ input: Operations.BlogPostGet.Input
    ) async throws -> Operations.BlogPostGet.Output {
        let useCase = self.useCases.makeGetPost()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.blogPostId)
        )

        return .ok(.init(body: .json(mapPostDetail(result))))
    }

    private func mapPostDetail(
        _ detail: Post.Detail.Output
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
                publicationDate: detail.metadata.publicationDate.timeIntervalSince1970,
                expirationDate: detail.metadata.expirationDate?.timeIntervalSince1970,
                status: detail.metadata.status.rawValue,
                title: detail.metadata.title,
                excerpt: detail.metadata.excerpt,
                imageUrl: detail.metadata.imageURL,
                canonicalUrl: detail.metadata.canonicalURL,
                noIndex: detail.metadata.noIndex,
                primaryKeyword: detail.metadata.primaryKeyword ?? "",
                cssCodeInjection: detail.metadata.cssCodeInjection,
                javascriptCodeInjection: detail.metadata.javascriptCodeInjection,
                structuredDataCodeInjection: detail.metadata.structuredDataCodeInjection,
                createdAt: detail.metadata.createdAt.timeIntervalSince1970,
                updatedAt: detail.metadata.updatedAt.timeIntervalSince1970
            ),
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }
}
