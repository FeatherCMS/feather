public import FeatherApplication
public import MediaModule

extension Asset.Folder.Edit {
    public enum Error: UseCaseError {
        case invalidName, notFound, duplicatePath
    }
}
