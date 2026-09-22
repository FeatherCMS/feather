protocol AdminRemoveContactSubmissionsInteractor: Sendable {
    func remove(ids: [String]) async throws
}
