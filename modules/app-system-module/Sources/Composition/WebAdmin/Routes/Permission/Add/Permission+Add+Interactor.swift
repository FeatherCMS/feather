import FeatherWebAdmin
import Hummingbird
import SystemModule

extension Permission.Add {
    enum Interactor {}
}

extension Permission.Add.Interactor {
    protocol Interface: Sendable {

        func execute(
            entity: Permission.Add.Model
        ) async throws
    }
}
