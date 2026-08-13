import ContactAdminAPI
import ContactApplication
import ContactDomain
import FeatherApplication
import FeatherContracts

extension ContactBackend {
    public func formFieldCreate(
        _ input: Operations.FormFieldCreate.Input
    ) async throws -> Operations.FormFieldCreate.Output {
        let body: Components.Schemas.FormFieldCreateSchema
        switch input.body {
        case .json(let value): body = value
        }

        guard let type = FormField.ItemType(rawValue: body._type) else {
            throw FormField.Error.optionsNotAllowed
        }

        let result = try await self.makeCreateFormField()
            .execute(
                subject: try await CurrentSubject.require(),
                input:
                    .init(
                        formId: input.path.contactFormId,
                        key: body.key,
                        type: type,
                        label: body.label,
                        allowedValues: body.allowedValues?
                            .map {
                                .init(value: $0, label: $0)
                            } ?? [],
                        isRequired: body.isRequired ?? false,
                        position: body.position ?? 0
                    )
            )

        return .created(.init(body: .json(map(result))))
    }
}
