import Foundation

struct AdminEditSystemPermissionDefaultInteractor:
    AdminEditSystemPermissionInteractor
{
    let repository: any AdminEditSystemPermissionRepository

    func load(
        id: String
    ) async throws -> SystemPermissionDetailsModel {
        try await repository.load(id: id)
    }

    func update(
        id: String,
        input: SystemPermissionFormInput
    ) async throws {
        try await repository.update(id: id, input: input)
    }
}
