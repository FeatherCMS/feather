import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminContactFormDetails {
    let renderingEngine: any RenderingEngine

    init(renderingEngine: any RenderingEngine) {
        self.renderingEngine = renderingEngine
    }
}
