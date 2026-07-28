import Hummingbird

struct AdminContactFormDetails {
    let renderingEngine: any RenderingEngine

    init(renderingEngine: any RenderingEngine) {
        self.renderingEngine = renderingEngine
    }
}
