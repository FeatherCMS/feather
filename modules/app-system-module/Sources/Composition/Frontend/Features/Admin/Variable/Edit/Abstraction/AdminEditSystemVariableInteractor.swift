import FeatherAdmin
import Foundation

protocol AdminEditSystemVariableInteractor: Sendable {

    func load(
        id: String
    ) async throws -> SystemVariableDetailsModel

    func edit(
        id: String,
        input: SystemVariableEditFormInput
    ) async throws
}
