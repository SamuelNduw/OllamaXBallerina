import ballerina/http;
import ballerina/io;

public function main() returns error? {
    http:ClientConfiguration clientConfig = {
        timeout: -1
    };

    http:Client ollamaClient = check new ("localhost:11434", clientConfig);

    json payload = {
        "model": "llama3.2:1B",
        "prompt": "what is the capital city of china",
        "stream": false
    };

    http:Response response = check ollamaClient->post("/api/generate", payload);

    if response.statusCode == 200 {
        json jsonResponse = check response.getJsonPayload();

        if jsonResponse is map<json> {
            json responseField = jsonResponse["response"];
            
            if responseField is string {
                io:println("Answer: " + responseField);
            } else {
                io:println("The response field is not a string.");
            }
        } else {
            io:println("Response is not in expected JSON format.");
        }
    } else{
        io:println("Failed with status: " + response.statusCode.toString());
    }
}