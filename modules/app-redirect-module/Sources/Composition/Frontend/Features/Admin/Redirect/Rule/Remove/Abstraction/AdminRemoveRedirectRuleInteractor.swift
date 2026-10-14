protocol AdminRemoveRedirectRuleInteractor: Sendable {

    func delete(ids: [String]) async throws
}
