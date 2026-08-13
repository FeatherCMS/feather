import FeatherApplication
import FeatherContracts
import Foundation
import WebAdminAPI
import WebApplication
import WebDomain

extension WebBackend {

    /// Create metadata entry
    /*
     curl -i -X 'POST' \
        'http://127.0.0.1:8080/api/v1/admin/web/metadata' \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -d '{"slug":"homepage","status":"draft","title":"Homepage","excerpt":"","imageUrl":"","canonicalUrl":"","cssCodeInjection":"","javascriptCodeInjection":""}'
    */
    public func webMetadataCreate(
        _ input: Operations.WebMetadataCreate.Input
    ) async throws -> Operations.WebMetadataCreate.Output {

        let body: Components.Schemas.WebMetadataCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = makeAddMetadata()
        let subject = try await CurrentSubject.require()

        let pubDate = body.publicationDate.map(
            Date.init(timeIntervalSince1970:)
        )
        let expDate = body.expirationDate.map(Date.init(timeIntervalSince1970:))

        let addInput = AddMetadata.Input(
            referenceType: body.referenceType ?? "",
            referenceID: body.referenceId ?? "",
            slug: body.slug,
            template: body.template ?? "default",
            publicationDate: pubDate ?? Date(),
            expirationDate: expDate,
            status: .init(rawValue: body.status) ?? .draft,
            title: body.title,
            excerpt: body.excerpt,
            imageURL: body.imageUrl,
            canonicalURL: body.canonicalUrl,
            noIndex: body.noIndex ?? false,
            primaryKeyword: body.primaryKeyword ?? "",
            cssCodeInjection: body.cssCodeInjection,
            javascriptCodeInjection: body.javascriptCodeInjection,
            structuredDataCodeInjection: body.structuredDataCodeInjection
        )

        let result = try await useCase.execute(
            subject: subject,
            input: addInput
        )

        return .created(
            .init(
                body: .json(map(result))
            )
        )
    }
}
