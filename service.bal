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
    resource function post preIssueAccessTokenUpdateScopes(http:Request req) returns http:Response|error? {
        
        log:printInfo("Request Received to Update Scopes of the access token");
        ActionResponse respBody = {
            "actionStatus": "SUCCESS",
            "operations": [
                {
                    "op": "add",
                    "path": "/accessToken/scopes/-",
                    "value": "custom-scope-1"
                },
                {
                    "op": "remove",
                    "path": "/accessToken/scopes/0"
                },
                {
                    "op": "replace",
                    "path": "/accessToken/scopes/2",
                    "value": "groups"
                }
            ]
        };
        http:Response resp = new;
        resp.statusCode = 200;
        resp.setJsonPayload(respBody.toJson());

        return resp;
    }

    resource function post preIssueAccessTokenUpdateAudience(http:Request req) returns http:Response|error? {
        
        log:printInfo("Request Received to Update Audience of the access token");
        ActionResponse respBody = {
            "actionStatus": "SUCCESS",
            "operations": [
                {
                    "op": "add",
                    "path": "/accessToken/claims/aud/-",
                    "value": "https://myextension.com"
                },
                {
                    "op": "remove",
                    "path": "/accessToken/claims/aud/1"
                },
                {
                    "op": "replace",
                    "path": "/accessToken/claims/aud/0",
                    "value": "https://localhost:8090"
                }
            ]
        };
        http:Response resp = new;
        resp.statusCode = 200;
        resp.setJsonPayload(respBody.toJson());

        return resp;
    }

    resource function post preIssueAccessTokenUpdateOidcClaims(http:Request req) returns http:Response|error? {
        
        log:printInfo("Request Received to Update OIDC Claims of the access token");
        ActionResponse respBody = {
            "actionStatus": "SUCCESS",
            "operations": [
                {
                    "op": "remove",
                    "path": "/accessToken/claims/groups/0"
                },
                {
                    "op": "replace",
                    "path": "/accessToken/claims/groups/1",
                    "value": "verifiedGroup1"
                },
                {
                    "op": "replace",
                    "path": "/accessToken/claims/phone_number",
                    "value": "+94717525365"
                }
            ]
        };
        http:Response resp = new;
        resp.statusCode = 200;
        resp.setJsonPayload(respBody.toJson());

        return resp;
    }

    resource function post preIssueAccessTokenUpdateTokenExpiryTime(http:Request req) returns http:Response|error? {
        
        log:printInfo("Request Received to Update OIDC Claims of the access token");
        ActionResponse respBody = {
            "actionStatus": "SUCCESS",
            "operations": [
                {
                    "op": "replace",
                    "path": "/accessToken/claims/expires_in",
                    "value": "4000"
                }
            ]
        };
        http:Response resp = new;
        resp.statusCode = 200;
        resp.setJsonPayload(respBody.toJson());

        return resp;
    }

    resource function post preIssueAccessTokenAddCustomClaims(http:Request req) returns http:Response|error? {
        
        log:printInfo("Request Received to Add Custom Claims to the access token");
        ActionResponse respBody = {
            "actionStatus": "SUCCESS",
            "operations": [
                {
                    "op": "add",
                    "path": "/accessToken/claims/-",
                    "value": {
                        "name": "companyID",
                        "value": "LK-2292"
                    }
                },
                {
                    "op": "add",
                    "path": "/accessToken/claims/-",
                    "value": {
                        "name": "isPermanent",
                        "value": true
                    }
                },
                {
                    "op": "add",
                    "path": "/accessToken/claims/-",
                    "value": {
                        "name": "additionalRoles",
                        "value": [
                            "manager",
                            "accountant"
                        ]
                    }
                }
            ]
        };
        http:Response resp = new;
        resp.statusCode = 200;
        resp.setJsonPayload(respBody.toJson());

        return resp;
    }   

    resource function post preIssueAccessTokenError(http:Request req) returns http:Response|error? {
        
        log:printInfo("Request Received to simulate an error");
        ActionResponse respBody = {
            "actionStatus": "ERROR",
            "error": "access_denied",
            "error_description": "The user is not authorized to access the resource"
        };
        http:Response resp = new;
        resp.statusCode = 400;
        resp.setJsonPayload(respBody.toJson());

        return resp;
    }
}