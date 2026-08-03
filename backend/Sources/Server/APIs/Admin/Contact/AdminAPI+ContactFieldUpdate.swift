import AdminOpenAPI
import ContactApplication
import ContactDomain

extension AdminAPI {
    func contactFieldUpdate(
        _ input: Operations.ContactFieldUpdate.Input
    ) async throws -> Operations.ContactFieldUpdate.Output {
        try await modules.contact.authorize(
            permission: ContactPermissions.Items.update
        )
        let body: Components.Schemas.ContactFormItemPatchSchema
        switch input.body {
        case let .json(value): body = value
        }
        let result = try await modules.contact.makeUpdateContactFormItem()
            .execute(
                .init(
                    id: input.path.contactFormItemId,
                    formId: nil,
                    key: body.key,
                    type: body._type.flatMap(
                        ContactFormItem.ItemType.init(rawValue:)
                    ),
                    label: body.label,
                    allowedValues: body.allowedValues.map {
                        $0.map { .init(value: $0, label: $0) }
                    },
                    isRequired: body.isRequired,
                    position: body.position
                )
            )
        return .ok(.init(body: .json(map(result))))
    }
}
