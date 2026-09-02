import FeatherDomain

public protocol FormRepository: Repository {

    func list() async throws -> [Form]

    func findBy(
        id: String
    ) async throws -> Form?

    func insert(
        _ model: Form.New
    ) async throws -> Form

    func update(
        _ model: Form
    ) async throws -> Form

    func delete(
        ids: [String]
    ) async throws -> Bool
}
