public import BlogAdminAPI
import BlogApplication
import BlogModule
import WebApplication
import WebDomain
import FeatherDomain
import FeatherModuleKit
import Foundation
import WebModule

extension AdminAPIGateway {

    public func blogAuthorPut(
        _ input: Operations.BlogAuthorPut.Input
    ) async throws -> Operations.BlogAuthorPut.Output {
        let body: Components.Schemas.AuthorPutSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeEditAuthor()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.blogAuthorId,
                name: body.name.map { .set($0) } ?? .unchanged,
                excerpt: body.excerpt.map { .set($0) } ?? .unchanged,
                content: body.content.map { .set($0) } ?? .unchanged,
                profileImageAssetId: OptionalFieldChange(
                    value: body.profileImageAssetId ?? nil,
                    shouldApply: body.profileImageAssetId != nil
                ),
                metadata: nil
            )
        )

        return .ok(.init(body: .json(mapEditedAuthor(result))))
    }

    private func mapEditedAuthor(
        _ detail: Author.Edit.Output
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
