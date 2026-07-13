import AdminOpenAPI
import ContactApplication

extension AdminAPI {
    func contactFormItemList(_ input: Operations.ContactFormItemList.Input) async throws -> Operations.ContactFormItemList.Output {
        try await modules.contact.authorize(permission: ContactPermissions.Items.list)
        let result = try await modules.contact.makeListContactFormItems().execute(.init(formId: input.path.contactFormId))
        return .ok(.init(body: .json(result.map(map))))
    }
}
