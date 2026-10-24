extension Logout {
    enum Interactor {}
}

extension Logout.Interactor {
    protocol Interface: Sendable {

        func execute(
            entity: Logout.Model
        ) async
    }
}
