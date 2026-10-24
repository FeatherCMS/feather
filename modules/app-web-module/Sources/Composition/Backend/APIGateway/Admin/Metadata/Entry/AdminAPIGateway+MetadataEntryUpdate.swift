import FeatherDomain
import FeatherModuleKit
import Foundation
import Hummingbird
public import WebAdminAPI
import WebApplication
import WebDomain
import WebModule

extension AdminAPIGateway {

    public func metadataUpdate(
        _ input: Operations.MetadataUpdate.Input
    ) async throws -> Operations.MetadataUpdate.Output {
        let body: Components.Schemas.MetadataCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let template = try FieldChange(
            value: body.template,
            shouldApply: true,
            onMissing: { HTTPError(.badRequest) }
        )
        let slug = try FieldChange(
            value: body.slug,
            shouldApply: true,
            onMissing: { HTTPError(.badRequest) }
        )
        let publicationDate = try FieldChange(
            value: body.publicationDate.map(Date.init(timeIntervalSince1970:)),
            shouldApply: true,
            onMissing: { HTTPError(.badRequest) }
        )
        let status = try FieldChange(
            value: Metadata.Model.Status(rawValue: body.status),
            shouldApply: true,
            onMissing: { HTTPError(.badRequest) }
        )
        let noIndex = try FieldChange(
            value: body.noIndex,
            shouldApply: true,
            onMissing: { HTTPError(.badRequest) }
        )

        let useCase = useCases.makeEditMetadata()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.metadataId,
                template: template,
                slug: slug,
                publicationDate: publicationDate,
                expirationDate: .init(
                    value: body.expirationDate.map(
                        Date.init(timeIntervalSince1970:)
                    ),
                    shouldApply: true
                ),
                status: status,
                title: .init(value: body.title, shouldApply: true),
                excerpt: .init(value: body.excerpt, shouldApply: true),
                imageURL: .init(value: body.imageUrl, shouldApply: true),
                canonicalURL: .init(
                    value: body.canonicalUrl,
                    shouldApply: true
                ),
                noIndex: noIndex,
                primaryKeyword: .init(
                    value: body.primaryKeyword,
                    shouldApply: true
                ),
                cssCodeInjection: .init(
                    value: body.cssCodeInjection,
                    shouldApply: true
                ),
                javascriptCodeInjection: .init(
                    value: body.javascriptCodeInjection,
                    shouldApply: true
                ),
                structuredDataCodeInjection: .init(
                    value: body.structuredDataCodeInjection,
                    shouldApply: true
                )
            )
        )

        return .ok(
            .init(
                body: .json(mapEditedMetadata(result))
            )
        )
    }

    func mapEditedMetadata(
        _ output: Metadata.Edit.Output
    ) -> Components.Schemas.MetadataDetailSchema {
        let availability = Metadata.Model.Availability(
            status: output.status,
            publicationDate: output.publicationDate,
            expirationDate: output.expirationDate,
            at: .now
        )
        return .init(
            id: output.id,
            referenceType: output.referenceType,
            referenceId: output.referenceID,
            slug: output.slug,
            template: output.template,
            publicationDate: output.publicationDate.timeIntervalSince1970,
            expirationDate: output.expirationDate?.timeIntervalSince1970,
            status: output.status.rawValue,
            availability: .init(rawValue: availability.rawValue) ?? .draft,
            title: output.title,
            excerpt: output.excerpt,
            imageUrl: output.imageURL,
            canonicalUrl: output.canonicalURL,
            noIndex: output.noIndex,
            primaryKeyword: output.primaryKeyword ?? "",
            cssCodeInjection: output.cssCodeInjection,
            javascriptCodeInjection: output.javascriptCodeInjection,
            structuredDataCodeInjection: output.structuredDataCodeInjection,
            createdAt: output.createdAt.timeIntervalSince1970,
            updatedAt: output.updatedAt.timeIntervalSince1970
        )
    }
}
