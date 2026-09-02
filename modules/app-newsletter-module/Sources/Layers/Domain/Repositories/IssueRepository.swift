import FeatherDomain

public protocol IssueRepository: Repository {

    func list(
        newsletterId: String
    ) async throws -> [Issue]

    func findBy(
        id: String
    ) async throws -> Issue?

    func insert(
        _ model: Issue.New
    ) async throws -> Issue

    func update(
        _ model: Issue
    ) async throws -> Issue

    func delete(
        ids: [String]
    ) async throws -> Bool
}
