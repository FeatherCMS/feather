import FeatherBackend
import NIOHTTP1
import SystemApplication
import SystemBackend
import SystemDomain
import SystemModule
import Testing

@Suite
struct SystemErrorMappingTests {

    @Test
    func modelValidationErrorsMapToBadRequest() {
        let variable =
            SystemBackend.ErrorAdapter.adapt(
                SystemModule.Variable.Model.Error.keyTooShort
            ) as? any HTTPErrorRepresentable
        let permission =
            SystemBackend.ErrorAdapter.adapt(
                SystemModule.Permission.Model.Error.keyTooShort
            ) as? any HTTPErrorRepresentable

        #expect(variable?.status == .badRequest)
        #expect(permission?.status == .badRequest)
    }

    @Test
    func missingEditedRecordsMapToNotFound() {
        let variable =
            SystemBackend.ErrorAdapter.adapt(
                SystemModule.Variable.Edit.UseCase.Error.notFound
            ) as? any HTTPErrorRepresentable
        let permission =
            SystemBackend.ErrorAdapter.adapt(
                SystemModule.Permission.Edit.UseCase.Error.notFound
            ) as? any HTTPErrorRepresentable

        #expect(variable?.status == .notFound)
        #expect(permission?.status == .notFound)
    }
}
