public protocol SubmissionMailRepository: Sendable {
    func listBy(formId: String) async throws -> [SubmissionMail]
    func insert(_ model: SubmissionMail.New) async throws -> SubmissionMail
    func deleteBy(formId: String) async throws
}
