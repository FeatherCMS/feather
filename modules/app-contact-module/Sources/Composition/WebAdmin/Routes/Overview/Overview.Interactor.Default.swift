extension Contact.Overview.Interactor {
    struct Default: Interface {
        func getOverview() async throws -> Contact.Overview.Model {
            .init(title: "Contact module")
        }
    }
}
