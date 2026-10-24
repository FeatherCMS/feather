import FeatherBackend
import FeatherModuleKit
import FeatherInfrastructure
import NIOHTTP1
import Testing

@testable import Server

@Suite
struct HTTPErrorMappingTests {

    @Test
    func authorizationErrorsMapTo401And403() {
        let unauthorized =
            BackendErrorAdapter.adapt(
                AuthError(
                    kind: .unauthorized,
                    message: "Missing subject."
                )
            ) as! any HTTPErrorRepresentable
        let forbidden =
            BackendErrorAdapter.adapt(
                AuthError(
                    kind: .forbidden,
                    message: "Permission denied."
                )
            ) as! any HTTPErrorRepresentable

        #expect(unauthorized.status == .unauthorized)
        #expect(forbidden.status == .forbidden)
    }

    @Test
    func queryNotFoundMapsTo404() {
        let error =
            BackendErrorAdapter.adapt(QueryError.notFound)
            as! any HTTPErrorRepresentable

        #expect(error.status == .notFound)
    }

    @Test
    func duplicateRepositoryKeysMapTo409() {
        let error =
            BackendErrorAdapter.adapt(
                RepositoryError(
                    reason: .database(.duplicateKey),
                    logMessage: "duplicate key",
                    userFriendlyMessage: "Duplicate value."
                )
            ) as! any HTTPErrorRepresentable

        #expect(error.status == .conflict)
    }
}
