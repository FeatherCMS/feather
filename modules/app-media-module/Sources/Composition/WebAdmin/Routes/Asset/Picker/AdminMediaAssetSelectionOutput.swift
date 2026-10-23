public enum AdminMediaAssetSelectionOutput: Sendable {
    case singleInput(id: String)
    case multipleInputs(containerID: String, name: String)
    case callback(functionName: String)
}
