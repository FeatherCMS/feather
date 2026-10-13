import AuthDomain

actor MockCredentialRepository: CredentialRepository {
    private(set) var insertCallCount = 0
    private(set) var insertedModel: Credential.New?
    private let result: Credential?

    init(result: Credential?) {
        self.result = result
    }

    func findBy(id: String) async throws -> Credential? { result }
    func findBy(userId: String) async throws -> Credential? { result }
    func findBy(email: String) async throws -> Credential? { result }
    func insert(_ model: Credential.New) async throws -> Credential {
        insertCallCount += 1
        insertedModel = model
        guard let result else { fatalError("missing credential result") }
        return result
    }
    func update(_ model: Credential) async throws -> Credential { model }
    func delete(id: String) async throws -> Bool { false }
}
