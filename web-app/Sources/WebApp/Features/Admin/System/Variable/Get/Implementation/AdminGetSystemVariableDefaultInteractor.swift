import Foundation

struct AdminGetSystemVariableDefaultInteractor: AdminGetSystemVariableInteractor
{
    let repository: any AdminGetSystemVariableRepository

    func execute(
        entity: AdminGetSystemVariableModel
    ) async throws -> SystemVariableDetailsModel {
        try await repository.get(id: entity.id)
    }
}
