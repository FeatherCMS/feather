import AccountAppAPI
import Hummingbird

extension AppAPIGateway {

    public func accountRegister(
        _ input: Operations.AccountRegister.Input
    ) async throws -> Operations.AccountRegister.Output {
        throw HTTPError(.forbidden)
    }
}
