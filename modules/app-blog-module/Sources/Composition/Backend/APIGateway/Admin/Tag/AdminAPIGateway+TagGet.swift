public import BlogAdminAPI
import BlogApplication
import BlogModule
import FeatherModuleKit
import Foundation
import WebApplication
import WebDomain
import WebModule

extension AdminAPIGateway {

    public func blogTagGet(
        _ input: Operations.BlogTagGet.Input
    ) async throws -> Operations.BlogTagGet.Output {
        let useCase = self.useCases.makeGetTag()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.blogTagId)
        )

        return .ok(.init(body: .json(mapTag(result))))
    }
}

extension AdminAPIGateway {
    private func mapTag(_ detail: Tag.Detail.Output)
        -> Components.Schemas.TagGetSchema
    {
        .init(
            id: detail.id,
            title: detail.title,
            excerpt: detail.excerpt,
            content: detail.content,
            imageAssetId: detail.imageAssetId,
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
}
