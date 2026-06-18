import AdminOpenAPI
import Application

extension AdminAPI {

    func authLogout(
        _ input: Operations.AuthLogout.Input
    ) async throws -> Operations.AuthLogout.Output {
        guard (try? await CurrentSubject.require()) != nil else {
            return .unauthorized
        }
        return .noContent
    }
}
