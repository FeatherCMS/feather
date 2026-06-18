import Foundation

struct AdminEditSystemVariableDefaultInteractor:
    AdminEditSystemVariableInteractor
{
    let repository: any AdminEditSystemVariableRepository

    func load(
        id: String
    ) async throws -> SystemVariableDetailsModel {
        try await repository.load(id: id)
    }

    func update(
        id: String,
        input: SystemVariableFormInput
    ) async throws {
        try await repository.update(id: id, input: input)
    }
}
