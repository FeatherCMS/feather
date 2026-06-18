import AdminOpenAPI
import WebApplication
import WebDomain
import Application
import Foundation

extension AdminAPI {

    /// Create metadata entry
    /*
     curl -i -X 'POST' \
        'http://127.0.0.1:8080/api/v1/admin/web/metadata' \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -d '{"slug":"homepage","status":"draft","title":"Homepage","excerpt":"","imageUrl":"","canonicalUrl":"","cssCodeInjection":"","javascriptCodeInjection":""}'
    */
    func webMetadataCreate(
        _ input: Operations.WebMetadataCreate.Input
    ) async throws -> Operations.WebMetadataCreate.Output {

        let body: Components.Schemas.WebMetadataCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.web.makeAddMetadata()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                referenceType: body.referenceType,
                referenceID: body.referenceId,
                slug: body.slug,
                publicationDate: body.publicationDate.map(
                    Date.init(timeIntervalSince1970:)
                ),
                expirationDate: body.expirationDate.map(
                    Date.init(timeIntervalSince1970:)
                ),
                status: .init(rawValue: body.status) ?? .draft,
                title: body.title,
                excerpt: body.excerpt,
                imageURL: body.imageUrl,
                canonicalURL: body.canonicalUrl ?? "",
                noIndex: body.noIndex ?? false,
                primaryKeyword: body.primaryKeyword ?? "",
                cssCodeInjection: body.cssCodeInjection ?? "",
                javascriptCodeInjection: body.javascriptCodeInjection ?? "",
                structuredDataCodeInjection: body.structuredDataCodeInjection
                    ?? ""
            )
        )

        return .created(
            .init(
                body: .json(map(result))
            )
        )
    }
}
