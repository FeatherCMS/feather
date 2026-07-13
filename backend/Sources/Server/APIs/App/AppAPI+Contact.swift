import AppOpenAPI
import ContactApplication
import Foundation

extension AppAPI {
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
