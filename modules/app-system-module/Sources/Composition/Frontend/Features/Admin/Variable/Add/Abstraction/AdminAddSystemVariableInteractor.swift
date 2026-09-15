import FeatherAdmin
import Foundation

protocol AdminAddSystemVariableInteractor: Sendable {

    func add(
        input: SystemVariableAddFormInput
    ) async throws
}
