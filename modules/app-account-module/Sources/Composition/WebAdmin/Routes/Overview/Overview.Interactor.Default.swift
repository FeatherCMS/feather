extension Overview.Interactor {

    struct Default: Interface {
        func getOverview() async throws -> Overview.Model {
            .init(title: "Account module")
        }
    }
}
