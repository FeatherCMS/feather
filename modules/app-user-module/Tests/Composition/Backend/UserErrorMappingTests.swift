import FeatherBackend
import NIOHTTP1
import Testing
import UserApplication
import UserDomain
import UserModule

@Suite
struct UserErrorMappingTests {

    @Test
    func roleModelValidationErrorsMapToBadRequest() {
        let error = Role.Model.Error.keyTooShort as any HTTPErrorRepresentable

        #expect(error.status == .badRequest)
        #expect(
            (error.content as? DefaultHTTPErrorContent)?.reason == "keyTooShort"
        )
    }

    @Test
    func missingRecordsMapToNotFound() {
        let identity =
            Identity.Edit.UseCase.Error.identityNotFound
            as any HTTPErrorRepresentable
        let missingRoleDuringIdentityEdit =
            Identity.Edit.UseCase.Error.roleNotFound
            as any HTTPErrorRepresentable
        let role =
            Role.Edit.UseCase.Error.notFound as any HTTPErrorRepresentable

        #expect(identity.status == .notFound)
        #expect(missingRoleDuringIdentityEdit.status == .notFound)
        #expect(role.status == .notFound)
    }
}
