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
        let error =
            UserBackend.ErrorAdapter.adapt(
                Role.Model.Error.keyTooShort
            ) as? any HTTPErrorRepresentable

        #expect(error?.status == .badRequest)
        #expect(
            (error?.content as? DefaultHTTPErrorContent)?.reason
                == "keyTooShort"
        )
    }

    @Test
    func missingRecordsMapToNotFound() {
        let identity =
            UserBackend.ErrorAdapter.adapt(
                Identity.Edit.UseCase.Error.identityNotFound
            ) as? any HTTPErrorRepresentable
        let missingRoleDuringIdentityEdit =
            UserBackend.ErrorAdapter.adapt(
                Identity.Edit.UseCase.Error.roleNotFound
            ) as? any HTTPErrorRepresentable
        let role =
            UserBackend.ErrorAdapter.adapt(
                Role.Edit.UseCase.Error.notFound
            ) as? any HTTPErrorRepresentable

        #expect(identity?.status == .notFound)
        #expect(missingRoleDuringIdentityEdit?.status == .notFound)
        #expect(role?.status == .notFound)
    }
}
