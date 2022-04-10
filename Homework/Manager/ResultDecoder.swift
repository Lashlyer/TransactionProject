
import Foundation

public class ResultDecoder {
    
    public static func parser(_ data: Data) throws -> [DataResponse] {
        do {
            let response = try JSONDecoder().decode([DataResponse].self, from: data)
            return response
            
        } catch {
            let errorText = "error:\(error) Json_Decoder_Error : " + String(decoding: data, as: UTF8.self)
            throw AppError(errorText)
        }
    }
}
