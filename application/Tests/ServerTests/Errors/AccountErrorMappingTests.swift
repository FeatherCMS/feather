import AccountApplication
import FeatherInfrastructure
import NIOHTTP1
import Testing

@testable import Server

@Suite
struct AccountErrorMappingTests {

    @Test
    func repositoryNotFoundIsTraceableAsHTTPError() {
        let error = RepositoryError.notFound

        let mapped = error as any HTTPErrorRepresentable

        #expect(mapped.status == .notFound)
    }

    @Test
    func invitationErrorsAreTraceableAsNotFoundHTTPErrors() {
        let errors: [any Error] = [
            AccountApplication.ResendInvitation.Error(
                message: "Invitation not found"
            ),
            AccountApplication.CompleteInvitationRegistration.Error(
                message: "Invitation not found"
            ),
            AccountApplication.ValidateInvitation.Error(
                message: "Invitation not found"
            )
        ]

        for error in errors {
            let mapped = error as! any HTTPErrorRepresentable
            #expect(mapped.status == .notFound)
        }
    }
}
