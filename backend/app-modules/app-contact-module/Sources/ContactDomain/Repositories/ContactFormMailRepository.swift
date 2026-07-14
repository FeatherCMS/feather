public protocol ContactFormMailRepository: Sendable {
    func listBy(formId: String) async throws -> [ContactFormMail]
    func insert(_ model: ContactFormMail.New) async throws -> ContactFormMail
    func deleteBy(formId: String) async throws
}
