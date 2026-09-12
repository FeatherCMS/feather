protocol AdminGetSystemJobInteractor: Sendable {
    func execute(entity: AdminGetSystemJobModel) async throws
        -> SystemJobDetailsModel
}
