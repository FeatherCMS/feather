import FeatherAdmin
import Foundation
import SystemAdminAPI

protocol AdminEditSystemVariableRepository: Sendable {

    func load(
        id: String
    ) async throws -> SystemVariableDetailsModel

    func update(
        id: String,
        input: Components.Schemas.SystemVariableCreateSchema
    ) async throws
}
