import AdminOpenAPI
import ContactApplication

extension AdminAPI {
    func contactFormList(
        _ input: Operations.ContactFormList.Input
    ) async throws -> Operations.ContactFormList.Output {
        try await modules.contact.authorize(
            permission: ContactPermissions.Forms.list
        )
        let result = try await modules.contact.makeListContactForms()
            .execute(.init())
        return .ok(.init(body: .json(result.map(map))))
    }
}
