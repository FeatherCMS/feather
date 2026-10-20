import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Permission.Add {
    enum Interactor {}
}

extension WebAdmin.System.Permission.Add.Interactor {
    protocol Interface: Sendable {

        func execute(
            entity: WebAdmin.System.Permission.Add.Model
        ) async throws
    }
}
