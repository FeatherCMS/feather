import UserDomain
import UserModule

actor MockRoleRepository: Role.Repository.Interface {
    func findBy(id: String) async throws -> Role.Model? { nil }

    func findBy(name: String) async throws -> Role.Model? { nil }

    func findBy(key: String) async throws -> Role.Model? { nil }

    func insert(_ model: Role.Model.New) async throws -> Role.Model {
        fatalError("not needed")
    }

    func update(_ model: Role.Model) async throws -> Role.Model { model }

    func delete(ids: [String]) async throws -> [String] { [] }
}
