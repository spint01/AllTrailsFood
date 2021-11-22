import Foundation

public struct HTTPHeader {
    let key: String
    let value: String
    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}

public enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}

public enum WebServiceError: Error, LocalizedError {
    case general
    case noData
    case parse
    case notModified
    case serverMessage(message: String)
    case client(statusCode: Int)
    case server(statusCode: Int)
    
    public var errorDescription: String? {
        switch self {
        case .general:
            return "Something went wrong"
        case .noData:
            return "No data available"
        case .parse:
            return "Parsing error encountered"
        case .notModified:
            return "Data not modified"
        case let .serverMessage(message):
            return message
        case let .client(statusCode):
            return HTTPURLResponse.localizedString(forStatusCode: statusCode)
        case let .server(statusCode):
            return HTTPURLResponse.localizedString(forStatusCode: statusCode)
        }
    }
}

extension Error {
    public var statusCode: Int? {
        if let webServiceError = self as? WebServiceError {
            switch webServiceError {
            case let .client(statusCode: statusCode): return statusCode
            case let .server(statusCode: statusCode): return statusCode
            default: return nil
            }
        }
        return nil
    }
}

open class WebService<T> {
    public init() {}

    open var urlString: String {
        fatalError("Must override WebService class implementation for urlString")
    }

    open var parse: (Data) throws -> Result<T, Error> {
        fatalError("Must override WebService class implementation for parse")
    }

    open var httpMethod: HTTPMethod {
        return .GET
    }

    open var parameters: [URLQueryItem] {
        return []
    }

    open var headers: [HTTPHeader] {
        return []
    }

    open var httpBodyData: Data? {
        return nil
    }

    open var etag: String? {
        get { return nil }
        set {}
    }

    public func load(shouldEncodePlusSign: Bool = false, completion: @escaping (Response<T, Error>) -> ()) {
        let resource = Resource<T>(urlString: urlString, httpMethod: httpMethod, parameters: parameters, httpBodyData: httpBodyData, headers: headers, parse: parse)
        resource.shouldEncodePlusSign = shouldEncodePlusSign
        load(resource: resource, completion: completion)
    }

    open func load(resource: Resource<T>, completion: @escaping (Response<T, Error>) -> ()) {
        if let etag = etag {
            resource.etag = etag
        }
        guard let urlRequest = resource.urlRequest else {
            self.call(completion: completion, with: Response(httpURLResponse: nil, result: Result.failure(WebServiceError.general)))
            return
        }
        if let bodyData = urlRequest.httpBody {
            print("REQUEST: \(urlRequest.httpMethod ?? "No Method"): \(urlRequest.url?.absoluteString.removingPercentEncoding ?? "No Url")\nheaders: \(urlRequest.allHTTPHeaderFields ?? [:]) \nbody: \(String(data: bodyData, encoding: .utf8) ?? "Data could not be printed")")
        }
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            do {
                print("RESPONSE: \((response as? HTTPURLResponse)?.statusCode ?? 0): \(urlRequest.httpMethod ?? "No Method"): \(urlRequest.url?.absoluteString.removingPercentEncoding ?? "No Url")")
                if let error = error {
                    throw error
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw WebServiceError.general
                }
                
                guard 200...299 ~= httpResponse.statusCode else {
                    let error: WebServiceError
                    switch httpResponse.statusCode {
                    case 304:
                        error = WebServiceError.notModified
                     case 400...499:
                        error = WebServiceError.client(statusCode: httpResponse.statusCode)
                    case 500...599:
                        error = WebServiceError.client(statusCode: httpResponse.statusCode)
                    default:
                        error = WebServiceError.general
                    }
                    throw error
                }
                
                guard let data = data else {
                    throw WebServiceError.noData
                }

                let response = Response(httpURLResponse: httpResponse, result: try resource.parse(data))
                self.etag = response.etag // save of etag from response
                self.call(completion: completion, with: response)
            } catch {
                self.call(completion: completion, with: Response(httpURLResponse: response as? HTTPURLResponse, result: Result.failure(error)))
            }
        }.resume()
    }

    private func call<T>(completion: @escaping (Response<T, Error>) ->(), with result: Response<T, Error>) {
        DispatchQueue.main.async() {
            completion(result)
        }
    }
    
   public func encodeParameters(_ parameters: [String: AnyObject]) throws -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += try queryComponents(key, value)
        }
        
        return (components.map { "\($0)=\($1)" } as [String]).joined(separator: "&")
    }
    
    public func queryComponents(_ key: String, _ value: AnyObject) throws -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let value = value as? [String: AnyObject] {
            let json = try JSONSerialization.data(withJSONObject: value, options: [])
            if let jsonString = String(data: json, encoding: .utf8) {
                components.append((try escape(key), try escape(jsonString)))
            }
        } else if let value = value as? [AnyObject] {
            let json = try JSONSerialization.data(withJSONObject: value, options: [])
            if let jsonString = String(data: json, encoding: .utf8) {
                components.append((try escape(key), try escape(jsonString)))
            }
        } else {
            components.append((try escape(key), try escape("\(value)")))
        }
        
        return components
    }
    
    func escape(_ string: String) throws -> String {
        let delimiters = ":#[]@"
        let subDelimiters = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: delimiters + subDelimiters)
        
        guard let escaped =  string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) else {
            throw WebServiceError.general
        }
        return escaped
    }
}
