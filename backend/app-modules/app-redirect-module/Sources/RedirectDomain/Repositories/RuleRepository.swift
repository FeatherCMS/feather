import Domain

public protocol RuleRepository: Repository {

    func find(
        id: String
    ) async throws -> Rule?

    func find(
        source: String
    ) async throws -> Rule?

    func insert(
        _ model: Rule.New
    ) async throws -> Rule

    func update(
        _ model: Rule
    ) async throws -> Rule

    func delete(
        id: String
    ) async throws -> Bool
}
