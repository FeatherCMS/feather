import FeatherAdmin
import FeatherValidation
import Foundation
import SystemAdminAPI

struct AdminAddSystemVariableDefaultInteractor: AdminAddSystemVariableInteractor
{
    let repository: any AdminAddSystemVariableRepository

    func add(
        input: SystemVariableAddFormInput
    ) async throws {
        try await input.validate()
        try await repository.create(
            input: .init(
                key: input.normalizedKey,
                value: input.normalizedValue,
                name: input.normalizedName,
                notes: input.normalizedNotes
            )
        )
    }
}
