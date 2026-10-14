protocol AdminRemoveRedirectRuleRepository: Sendable {

    func delete(ids: [String]) async throws
}
