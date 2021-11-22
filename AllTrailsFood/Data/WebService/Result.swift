import Foundation

public enum Result<T, E> {
    case success(T)
    case failure(E)
}

public extension Result where E: Error {
    func resolve() throws -> T {
        switch self {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
}

public enum GenericError: Error, LocalizedError {
    case custom(message: String)

    public var errorDescription: String? {
        switch self {
        case let .custom(message):
            return message
        }
    }
}

public enum CoreDataError: Error, LocalizedError {

    case delete
    case noContext
    case custom(message: String)

    public var errorDescription: String? {
        switch self {
        case .delete:
            return "Failed to delete"
        case .noContext:
            return "Failed to create CoreData context"
        case let .custom(message):
            return message
        }
    }
}
