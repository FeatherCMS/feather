public import FeatherApplication
public import MediaModule

extension Asset.File.Edit {
    public struct Error: UseCaseError {
        let message: String
    }
}
