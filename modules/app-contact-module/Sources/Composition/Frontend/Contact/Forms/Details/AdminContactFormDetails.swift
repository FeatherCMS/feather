import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminContactFormDetails {
    let renderingEngine: any RenderingEngine

    init(renderingEngine: any RenderingEngine) {
        self.renderingEngine = renderingEngine
    }
}
