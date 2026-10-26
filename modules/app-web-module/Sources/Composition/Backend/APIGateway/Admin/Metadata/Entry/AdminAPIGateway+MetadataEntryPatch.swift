import FeatherBackend
import FeatherDomain
import FeatherModuleKit
import Foundation
import Hummingbird
public import WebAdminAPI
import WebApplication
import WebDomain
import WebModule

extension AdminAPIGateway {

    private enum UpdateMaskFields: String, Sendable {
        case template
        case slug
        case publicationDate
        case expirationDate
        case status
        case title
        case excerpt
        case imageUrl
        case canonicalUrl
        case noIndex
        case primaryKeyword
        case cssCodeInjection
        case javascriptCodeInjection
        case structuredDataCodeInjection
    }

    public func metadataPatch(
        _ input: Operations.MetadataPatch.Input
    ) async throws -> Operations.MetadataPatch.Output {
        let body: Components.Schemas.MetadataPatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let fields: UpdateMask<UpdateMaskFields>
        do {
            fields = try .init(input.query.updateMask)
        }
        catch {
            throw HTTPError(.badRequest)
        }

        let template = try FieldChange(
            value: body.template,
            shouldApply: fields.contains(.template),
            onMissing: { HTTPError(.badRequest) }
        )
        let slug = try FieldChange(
            value: body.slug,
            shouldApply: fields.contains(.slug),
            onMissing: { HTTPError(.badRequest) }
        )
        let publicationDate = try FieldChange(
            value: body.publicationDate.map(Date.init(timeIntervalSince1970:)),
            shouldApply: fields.contains(.publicationDate),
            onMissing: { HTTPError(.badRequest) }
        )
        let status = try FieldChange(
            value: body.status.flatMap(Metadata.Model.Status.init(rawValue:)),
            shouldApply: fields.contains(.status),
            onMissing: { HTTPError(.badRequest) }
        )
        let noIndex = try FieldChange(
            value: body.noIndex,
            shouldApply: fields.contains(.noIndex),
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
                    shouldApply: fields.contains(.expirationDate)
                ),
                status: status,
                title: .init(
                    value: body.title,
                    shouldApply: fields.contains(.title)
                ),
                excerpt: .init(
                    value: body.excerpt,
                    shouldApply: fields.contains(.excerpt)
                ),
                imageURL: .init(
                    value: body.imageUrl,
                    shouldApply: fields.contains(.imageUrl)
                ),
                canonicalURL: .init(
                    value: body.canonicalUrl,
                    shouldApply: fields.contains(.canonicalUrl)
                ),
                noIndex: noIndex,
                primaryKeyword: .init(
                    value: body.primaryKeyword,
                    shouldApply: fields.contains(.primaryKeyword)
                ),
                cssCodeInjection: .init(
                    value: body.cssCodeInjection,
                    shouldApply: fields.contains(.cssCodeInjection)
                ),
                javascriptCodeInjection: .init(
                    value: body.javascriptCodeInjection,
                    shouldApply: fields.contains(.javascriptCodeInjection)
                ),
                structuredDataCodeInjection: .init(
                    value: body.structuredDataCodeInjection,
                    shouldApply: fields.contains(.structuredDataCodeInjection)
                )
            )
        )

        return .ok(
            .init(
                body: .json(mapEditedMetadata(result))
            )
        )
    }
}
