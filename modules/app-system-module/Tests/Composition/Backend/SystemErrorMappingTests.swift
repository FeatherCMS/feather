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
        let variable = SystemModule.Variable.Model.Error.keyTooShort
            as any HTTPErrorRepresentable
        let permission = SystemModule.Permission.Model.Error.keyTooShort
            as any HTTPErrorRepresentable

        #expect(variable.status == .badRequest)
        #expect(permission.status == .badRequest)
    }

    @Test
    func missingEditedRecordsMapToNotFound() {
        let variable = SystemModule.Variable.Edit.UseCase.Error.notFound
            as any HTTPErrorRepresentable
        let permission = SystemModule.Permission.Edit.UseCase.Error.notFound
            as any HTTPErrorRepresentable

        #expect(variable.status == .notFound)
        #expect(permission.status == .notFound)
    }
}
