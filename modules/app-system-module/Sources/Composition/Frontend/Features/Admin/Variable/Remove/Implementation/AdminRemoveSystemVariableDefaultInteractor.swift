import FeatherAdmin
import Foundation

struct AdminRemoveSystemVariableDefaultInteractor:
    AdminRemoveSystemVariableInteractor
{
    let repository: any AdminRemoveSystemVariableRepository

    func delete(
        ids: [String]
    ) async throws {
        try await repository.delete(ids: ids)
    }

    func names(ids: [String]) async throws -> [String] {
        try await repository.names(ids: ids)
    }
}
