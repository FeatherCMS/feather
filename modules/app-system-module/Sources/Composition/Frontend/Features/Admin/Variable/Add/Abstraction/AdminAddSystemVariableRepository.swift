import FeatherAdmin
import Foundation
import SystemAdminAPI

protocol AdminAddSystemVariableRepository: Sendable {

    func create(
        input: Components.Schemas.SystemVariableCreateSchema
    ) async throws
}
