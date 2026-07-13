import Domain

public protocol ContactFormSubmissionRepository: Repository {

    func listBy(
        formId: String
    ) async throws -> [ContactFormSubmission]

    func findBy(
        id: String
    ) async throws -> ContactFormSubmission?

    func insert(
        _ model: ContactFormSubmission.New
    ) async throws -> ContactFormSubmission

    func update(
        _ model: ContactFormSubmission
    ) async throws -> ContactFormSubmission
}
