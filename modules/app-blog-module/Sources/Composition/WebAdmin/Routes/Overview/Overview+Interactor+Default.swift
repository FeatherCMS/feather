import FeatherWebAdmin

extension Overview.Interactor {
    struct Default: Interface {
        func execute() async throws -> Overview.Model {
            .init(title: "Blog module")
        }
    }
}
