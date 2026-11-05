extension Logout.Interactor {
    struct Default: Interface {
        private let repository: any Logout.Repository.Interface

        init(repository: any Logout.Repository.Interface) {
            self.repository = repository
        }

        func execute(
            entity: Logout.Model
        ) async {
            try? await repository.logout(sessionToken: entity.sessionToken)
        }
    }
}
