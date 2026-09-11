import FeatherAdmin
import Foundation

struct AdminRemoveSystemVariableDefaultInteractor:
    AdminRemoveSystemVariableInteractor
{
    let repository: any AdminRemoveSystemVariableRepository

    func delete(
        ids: [String]
    ) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }
}
