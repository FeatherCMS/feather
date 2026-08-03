protocol AdminRemoveContactSubmissionsInteractor: Sendable {
    func bulkRemove(ids: [String]) async throws
}
