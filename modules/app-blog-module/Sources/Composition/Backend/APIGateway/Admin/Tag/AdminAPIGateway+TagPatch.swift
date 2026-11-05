public import BlogAdminAPI
import BlogApplication
import BlogModule
import FeatherBackend
import FeatherDomain
import FeatherModuleKit
import Foundation
import WebApplication
import WebDomain
import WebModule

extension AdminAPIGateway {

    private enum UpdateMaskFields: String, Sendable {
        case title
        case excerpt
        case content
        case imageAssetId
    }

    public func blogTagPatch(
        _ input: Operations.BlogTagPatch.Input
    ) async throws -> Operations.BlogTagPatch.Output {
        let body: Components.Schemas.TagPatchSchema
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
            let title = requiredFieldChange(
                value: body.title,
                shouldApply: fields.contains(.title)
            )
        else {
            return .badRequest(
                .init(
                    body: .json(
                        badRequestErrorEnvelope(
                            reason: "Missing selected field: title"
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
        let imageAssetId = OptionalFieldChange(
            value: body.imageAssetId ?? nil,
            shouldApply: fields.contains(.imageAssetId)
        )

        let useCase = self.useCases.makeEditTag()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.blogTagId,
                title: title,
                excerpt: excerpt,
                content: content,
                imageAssetId: imageAssetId,
                metadata: nil
            )
        )

        return .ok(.init(body: .json(mapTag(result))))
    }
}

extension AdminAPIGateway {
    private func mapTag(_ output: Tag.Edit.Output)
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
