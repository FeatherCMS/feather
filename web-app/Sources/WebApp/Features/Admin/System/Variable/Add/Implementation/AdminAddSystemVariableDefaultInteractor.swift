import Foundation

struct AdminAddSystemVariableDefaultInteractor: AdminAddSystemVariableInteractor
{
    let repository: any AdminAddSystemVariableRepository

    func execute(
        input: SystemVariableFormInput
    ) async throws {
        try await repository.create(input: input)
    }
}
