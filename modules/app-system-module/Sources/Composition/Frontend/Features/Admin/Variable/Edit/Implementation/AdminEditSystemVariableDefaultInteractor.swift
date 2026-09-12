import FeatherAdmin
import FeatherValidation
import Foundation
import SystemAdminAPI

struct AdminEditSystemVariableDefaultInteractor:
    AdminEditSystemVariableInteractor
{
    let repository: any AdminEditSystemVariableRepository

    func load(
        id: String
    ) async throws -> SystemVariableEditModel {
        try await repository.load(id: id)
    }

    func edit(
        id: String,
        input: SystemVariableEditFormInput
    ) async throws {
        try await input.validate()
        try await repository.update(
            id: id,
            input: .init(
                key: input.normalizedKey,
                value: input.normalizedValue,
                name: input.normalizedName,
                notes: input.normalizedNotes
            )
        )
    }
}
