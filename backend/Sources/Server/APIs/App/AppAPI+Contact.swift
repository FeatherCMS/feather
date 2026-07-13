import AppOpenAPI
import ContactApplication
import ContactDomain
import Foundation

extension AppAPI {
    func appContactFormGet(
        _ input: Operations.AppContactFormGet.Input
    ) async throws -> Operations.AppContactFormGet.Output {
        let result = try await modules.contact.makeGetContactForm().execute(
            .init(id: input.path.contactFormId)
        )
        return .ok(.init(body: .json(.init(
            id: result.id,
            name: result.name,
            items: result.items.map {
                .init(id: $0.id, key: $0.key, _type: $0.type.rawValue, label: $0.label, allowedValues: $0.allowedValues.map(\.value), isRequired: $0.isRequired, position: $0.position)
            }
        ))))
    }

    func appContactFormSubmission(
        _ input: Operations.AppContactFormSubmission.Input
    ) async throws -> Operations.AppContactFormSubmission.Output {
        let body: Components.Schemas.AppContactFormSubmissionSchema
        switch input.body {
        case let .json(value): body = value
        }

        let valuesJSON = try String(decoding: JSONEncoder().encode(body.values), as: UTF8.self)
        let metadataJSON = try body.metadata.map { try String(decoding: JSONEncoder().encode($0), as: UTF8.self) }
        _ = try await modules.contact.makeSubmitContactForm().execute(.init(formId: input.path.contactFormId, valuesJSON: valuesJSON, itemsSnapshotJSON: "{}", metadataJSON: metadataJSON))
        return .created
    }
}
