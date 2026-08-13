import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebStandards

protocol AdminEditAuthAccessControlInteractor: Sendable {

    func loadState(
        isEdited: Bool,
        canEdit: Bool,
        selectedOverride: Set<String>?,
        error: String?
    ) async throws -> AdminEditAuthAccessControlState

    func save(
        input: AdminEditAuthAccessControlFormInput
    ) async throws -> AdminEditAuthAccessControlSaveResult
}
