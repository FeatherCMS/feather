import FeatherWebAdmin
import Hummingbird

extension Overview.Interactor {
    struct Default: Overview.Interactor.Interface {
        func getOverview() async throws -> Overview.Model {
            .init(title: "User module")
        }
    }
}
