public struct WebAppRuntime<Interactor, Presenter> {
    public let interactor: Interactor
    public let presenter: Presenter

    public init(interactor: Interactor, presenter: Presenter) {
        self.interactor = interactor
        self.presenter = presenter
    }
}
