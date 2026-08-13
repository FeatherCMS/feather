import FeatherDomain

public protocol SubmissionRepository: Repository {

    func listBy(
        formId: String
    ) async throws -> [Submission]

    func findBy(
        id: String
    ) async throws -> Submission?

    func insert(
        _ model: Submission.New
    ) async throws -> Submission

    func update(
        _ model: Submission
    ) async throws -> Submission

    func delete(
        id: String
    ) async throws -> Bool
}
