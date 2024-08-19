import ballerina/http;
import ballerina/log;
import ballerina/json;

enum ActionStatus {
    SUCCESS,
    ERROR
}

type OperationValue record {
    string name;
    string value;
};

type Operation record {
    string op;
    string path;
    string|OperationValue value?;
};

type ActionResponse record {
    ActionStatus actionStatus;
    Operation[] operations;
};

service / on new http:Listener(8090) {
    resource function post preIssueAccessTokenAddAud(http:Request req) returns http:Response|error? {
        
        log:printInfo("Request Received");
        ActionResponse respBody = {
            "actionStatus": "SUCCESS",
            "operations": [
                {
                "op": "add",
                "path": "/accessToken/claims/aud/-",
                "value": "https://example.com/resource"
                }
            ]
        };
        http:Response resp = new;
        resp.statusCode = 200;
        resp.setJsonPayload(respBody.toJson());

        return resp;
    }

    resource function post preIssueAccessTokenAddCustomClaim(http:Request req) returns http:Response|error? {
        
        log:printInfo("Request Received");
        ActionResponse respBody = {
            "actionStatus": "SUCCESS",
            "operations": [
                {
                    "op": "add",
                    "path": "/accessToken/claims/-",
                    "value": {
                        "name": "customSID",
                        "value": "12345"
                    }
                }
            ]
        };  
        http:Response resp = new;
        resp.statusCode = 200;
        resp.setJsonPayload(respBody.toJson());

        return resp;
    }   
}