extension Overview.Interactor {

    struct Default:
        Overview.Interactor.Interface
    {
        func getOverview() async throws -> Overview.Model {
            .init(title: "Account module")
        }
    }
}
