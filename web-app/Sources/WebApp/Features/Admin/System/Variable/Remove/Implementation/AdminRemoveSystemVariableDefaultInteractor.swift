import Foundation

struct AdminRemoveSystemVariableDefaultInteractor:
    AdminRemoveSystemVariableInteractor
{
    let repository: any AdminRemoveSystemVariableRepository

    func get(
        id: String
    ) async throws -> SystemVariableDetailsModel {
        try await repository.get(id: id)
    }

    func delete(
        id: String
    ) async throws {
        try await repository.delete(id: id)
    }
}
