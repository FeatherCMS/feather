import FeatherAdmin
import Foundation
import HTML

protocol AdminGetSystemVariablePresenter: Sendable {

    func renderDetailsPage(
        variable: SystemVariableDetailsModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String
    ) async throws -> HTMLResponse

}
