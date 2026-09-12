import FeatherAdmin
import Foundation

struct AdminRemoveSystemPermissionDefaultInteractor:
    AdminRemoveSystemPermissionInteractor
{
    let repository: any AdminRemoveSystemPermissionRepository

    func names(ids: [String]) async throws -> [String] {
        var result: [String] = []
        for id in ids {
            result.append(try await repository.get(id: id).name ?? "")
        }
        return result
    }

    func delete(ids: [String]) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }
}
