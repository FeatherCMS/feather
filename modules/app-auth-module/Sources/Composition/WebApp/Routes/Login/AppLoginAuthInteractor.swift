import AuthAppAPI
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebApp
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AppLoginAuthInteractor: Sendable {

    func execute(
        entity: AppLoginAuthModel
    ) async throws -> LoginResultModel
}
