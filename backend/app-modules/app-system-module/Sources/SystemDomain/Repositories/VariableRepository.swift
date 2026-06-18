import Domain

public protocol VariableRepository: Repository {

    func insert(
        _ model: Variable.New
    ) async throws -> Variable

    func update(
        _ model: Variable
    ) async throws -> Variable

    func find(
        id: String
    ) async throws -> Variable?

    func delete(
        id: String
    ) async throws -> Bool

}
