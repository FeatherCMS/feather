protocol AppLogoutAuthInteractor: Sendable {

    func execute(
        entity: AppLogoutAuthModel
    ) async
}
