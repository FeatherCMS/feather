import FeatherBackend
import AccountApplication
import FeatherInfrastructure
import NIOHTTP1
import RedirectApplication
import RedirectModule
import Testing
import AccountModule

@testable import Server

@Suite
struct AccountErrorMappingTests {

    @Test
    func repositoryNotFoundIsTraceableAsHTTPError() {
        let error = RepositoryError.notFound

        let mapped =
            BackendErrorAdapter.adapt(error) as! any HTTPErrorRepresentable

        #expect(mapped.status == .notFound)
    }

    @Test
    func invitationErrorsAreTraceableAsNotFoundHTTPErrors() {
        let errors: [any Error] = [
            Invitation.Resend.Error.invitationNotFound,
            Invitation.CompleteRegistration.Error(
                message: "Invitation not found"
            ),
            Invitation.Validate.Error(
                message: "Invitation not found"
            ),
        ]

        for error in errors {
            let mapped =
                BackendErrorAdapter.adapt(error) as! any HTTPErrorRepresentable
            #expect(mapped.status == .notFound)
        }
    }

    @Test
    func publicRedirectRuleNotFoundIsMappedToNotFound() {
        let error = Rule.Resolve.Error.notFound
        let mapped =
            BackendErrorAdapter.adapt(error) as! any HTTPErrorRepresentable

        #expect(mapped.status == .notFound)
    }
}
