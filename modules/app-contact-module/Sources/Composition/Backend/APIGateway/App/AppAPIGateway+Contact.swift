import ContactAppAPI
import ContactApplication
import ContactDomain
import Foundation

extension AppAPIGateway {
    public func appContactFormGet(
        _ input: Operations.AppContactFormGet.Input
    ) async throws -> Operations.AppContactFormGet.Output {
        let result = try await self.useCases.makeGetPublicForm()
            .execute(
                .init(id: input.path.contactFormId)
            )
        return .ok(
            .init(
                body: .json(
                    .init(
                        id: result.id,
                        name: result.name,
                        successMessage: result.successMessage,
                        failureMessage: result.failureMessage,
                        redirectUrl: result.redirectUrl,
                        items: result.fields.map {
                            .init(
                                id: $0.id,
                                key: $0.key,
                                _type: $0.type.rawValue,
                                label: $0.label,
                                allowedValues: $0.allowedValues.map(\.value),
                                isRequired: $0.isRequired,
                                position: $0.position
                            )
                        }
                    )
                )
            )
        )
    }

    public func appContactFormSubmission(
        _ input: Operations.AppContactFormSubmission.Input
    ) async throws -> Operations.AppContactFormSubmission.Output {
        let body: Components.Schemas.AppContactFormSubmissionSchema
        switch input.body {
        case .json(let value): body = value
        }

        let valuesJSON = try String(
            decoding: JSONEncoder().encode(body.values),
            as: UTF8.self
        )
        let metadataJSON = try body.metadata.map {
            try String(decoding: JSONEncoder().encode($0), as: UTF8.self)
        }
        let form = try await self.useCases.makeGetPublicForm()
            .execute(.init(id: input.path.contactFormId))
        _ = try await self.useCases.makeSubmitContactForm()
            .execute(
                .init(
                    formId: input.path.contactFormId,
                    valuesJSON: valuesJSON,
                    itemsSnapshotJSON: "{}",
                    metadataJSON: metadataJSON
                )
            )
        try await useCases.enqueueMailTasks(
            form: form,
            valuesJSON: valuesJSON
        )
        return .created(
            .init(body: .json(.init(redirectUrl: form.redirectUrl)))
        )
    }
}
