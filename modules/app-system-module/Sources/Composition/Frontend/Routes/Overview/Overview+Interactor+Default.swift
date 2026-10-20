import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Overview.Interactor {
    struct Default:
        WebAdmin.System.Overview.Interactor.Interface
    {
        func getOverview() async throws -> WebAdmin.System.Overview.Model {
            .init(title: "System module")
        }
    }
}
