import FeatherWebAdmin
import Hummingbird

extension Overview.Interactor {
    struct Default: Interface {
        func getOverview() async throws -> Overview.Model {
            .init(title: "User module")
        }
    }
}
