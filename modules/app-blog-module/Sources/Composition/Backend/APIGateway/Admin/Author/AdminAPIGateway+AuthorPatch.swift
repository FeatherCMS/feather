public import BlogAdminAPI
import BlogApplication
import BlogModule
import WebApplication
import WebDomain
import FeatherBackend
import FeatherDomain
import FeatherModuleKit
import Foundation
import WebModule

extension AdminAPIGateway {

    private enum UpdateMaskFields: String, Sendable {
        case name
        case excerpt
        case content
        case profileImageAssetId
    }

    public func blogAuthorPatch(
        _ input: Operations.BlogAuthorPatch.Input
    ) async throws -> Operations.BlogAuthorPatch.Output {
        let body: Components.Schemas.AuthorPatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let fields: UpdateMask<UpdateMaskFields>
        do {
            fields = try .init(input.query.updateMask)
        }
        catch {
            return .badRequest(
                .init(
                    body: .json(
                        badRequestErrorEnvelope(reason: "Invalid updateMask")
                    )
                )
            )
        }

        guard
            let name = requiredFieldChange(
                value: body.name,
                shouldApply: fields.contains(.name)
            )
        else {
            return .badRequest(
                .init(
                    body: .json(
                        badRequestErrorEnvelope(
                            reason: "Missing selected field: name"
                        )
                    )
                )
            )
        }
        guard
            let excerpt = requiredFieldChange(
                value: body.excerpt,
                shouldApply: fields.contains(.excerpt)
            )
        else {
            return .badRequest(
                .init(
                    body: .json(
                        badRequestErrorEnvelope(
                            reason: "Missing selected field: excerpt"
                        )
                    )
                )
            )
        }
        guard
            let content = requiredFieldChange(
                value: body.content,
                shouldApply: fields.contains(.content)
            )
        else {
            return .badRequest(
                .init(
                    body: .json(
                        badRequestErrorEnvelope(
                            reason: "Missing selected field: content"
                        )
                    )
                )
            )
        }
        let profileImageAssetId = OptionalFieldChange(
            value: body.profileImageAssetId ?? nil,
            shouldApply: fields.contains(.profileImageAssetId)
        )

        let useCase = self.useCases.makeEditAuthor()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.blogAuthorId,
                name: name,
                excerpt: excerpt,
                content: content,
                profileImageAssetId: profileImageAssetId,
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
