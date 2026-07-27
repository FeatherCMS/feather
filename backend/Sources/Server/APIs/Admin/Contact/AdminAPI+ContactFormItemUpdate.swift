import AdminOpenAPI
import ContactApplication
import ContactDomain

extension AdminAPI {
    func contactFormItemUpdate(
        _ input: Operations.ContactFormItemUpdate.Input
    ) async throws -> Operations.ContactFormItemUpdate.Output {
        try await modules.contact.authorize(
            permission: ContactPermissions.Items.update
        )
        let body: Components.Schemas.ContactFormItemPatchSchema
        switch input.body {
        case let .json(value): body = value
        }
        let type = body._type.flatMap(ContactFormItem.ItemType.init(rawValue:))
        let result = try await modules.contact.makeUpdateContactFormItem()
            .execute(
                .init(
                    id: input.path.contactFormItemId,
                    key: body.key,
                    type: type,
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
