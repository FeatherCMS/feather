import AdminOpenAPI
import Application
import ContactApplication
import ContactDomain

extension AdminAPI {
    func contactFormItemCreate(
        _ input: Operations.ContactFormItemCreate.Input
    ) async throws -> Operations.ContactFormItemCreate.Output {
        try await modules.contact.authorize(
            permission: ContactPermissions.Items.create
        )
        let body: Components.Schemas.ContactFormItemCreateSchema
        switch input.body {
        case let .json(value): body = value
        }

        guard let type = ContactFormItem.ItemType(rawValue: body._type) else {
            throw ContactFormItem.Error.optionsNotAllowed
        }

        let result = try await modules.contact.makeCreateContactFormItem()
            .execute(
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
