import FeatherWebAdmin
import Hummingbird
import SystemModule

extension Overview.Interactor {
    struct Default:
        Interface
    {
        func getOverview() async throws
            -> Overview.Model
        {
            .init(title: "System module")
        }
    }
}
