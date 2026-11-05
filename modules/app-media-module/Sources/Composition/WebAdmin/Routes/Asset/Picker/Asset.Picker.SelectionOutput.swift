public import MediaModule

extension Asset.Picker {
    public enum SelectionOutput: Sendable {
        case singleInput(id: String)
        case multipleInputs(containerID: String, name: String)
        case callback(functionName: String)
    }
}
