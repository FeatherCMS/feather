import AuthDomain
import AuthModule

actor MockCredentialRepository: Credential.Repository.Interface {
    private(set) var insertCallCount = 0
    private(set) var insertedModel: Credential.Model.New?
    private let result: Credential.Model?

    init(result: Credential.Model?) {
        self.result = result
    }

    func findBy(id: String) async throws -> Credential.Model? {
        result
    }
    func findBy(userId: String) async throws -> Credential.Model? {
        result
    }
    func findBy(email: String) async throws -> Credential.Model? {
        result
    }
    func insert(_ model: Credential.Model.New) async throws
        -> Credential.Model
    {
        insertCallCount += 1
        insertedModel = model
        guard let result else { fatalError("missing credential result") }
        return result
    }
    func update(_ model: Credential.Model) async throws
        -> Credential.Model
    { model }
    func delete(ids: [String]) async throws -> [String] { [] }
}
