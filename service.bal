import ballerina/http;
import ballerina/log;

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
resource function post preIssueAccessTokenAddAud(http:Request req) returns ActionResponse|error? {
     
     log:printInfo("Request Received");
     ActionResponse resp = {
        "actionStatus": "SUCCESS",
        "operations": [
            {
            "op": "add",
            "path": "/accessToken/claims/aud/-",
            "value": "https://example.com/resource"
            }
        ]
    };
     return resp;
}
}