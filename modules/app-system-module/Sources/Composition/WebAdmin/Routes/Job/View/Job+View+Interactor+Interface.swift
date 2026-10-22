import FeatherWebAdmin
import SystemModule

extension Job.View.Interactor {
    protocol Interface: Sendable {
        func execute(entity: Job.View.Model)
            async throws
            -> SystemJobDetailsModel
    }
}
