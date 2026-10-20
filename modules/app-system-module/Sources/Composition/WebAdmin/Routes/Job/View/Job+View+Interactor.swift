import FeatherAdmin
import SystemModule

extension Job.View {
    enum Interactor {}
}

extension Job.View.Interactor {
    protocol Interface: Sendable {
        func execute(entity: Job.View.Model)
            async throws
            -> SystemJobDetailsModel
    }
}
