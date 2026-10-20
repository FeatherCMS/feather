import FeatherAdmin
import SystemModule

extension WebAdmin.System.Job.View {
    enum Interactor {}
}

extension WebAdmin.System.Job.View.Interactor {
    protocol Interface: Sendable {
        func execute(entity: WebAdmin.System.Job.View.Model) async throws
            -> SystemJobDetailsModel
    }
}
