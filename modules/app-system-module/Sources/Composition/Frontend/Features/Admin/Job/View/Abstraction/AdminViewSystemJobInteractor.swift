protocol AdminViewSystemJobInteractor: Sendable {
    func execute(entity: AdminViewSystemJobModel) async throws
        -> SystemJobDetailsModel
}
