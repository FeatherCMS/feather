extension Overview.View.Interactor {
    struct Default: Interface {
        func getOverview() async throws -> Overview.View.Model {
            .init(title: "Analytics module")
        }
    }
}
