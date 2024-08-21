import ballerina/http;
import ballerina/log;

enum ActionSuccessStatus {
    SUCCESS
}

enum ActionFailedStatus {
    ERROR
}

enum OperationType {
    ADD = "add",
    REMOVE = "remove",
    REPLACE = "replace"
}

type OperationValue record {
    string name;
    string | string[] | boolean value;
};

type Operation record {
    string op;
    string path;
    string | OperationValue value?;
};

type ActionSuccessResponse record {
    ActionSuccessStatus actionStatus;
    Operation[] operations;
};

type ActionFailedResponse record {
    ActionFailedStatus actionStatus;
    string 'error;
    string error_description;
};

service / on new http:Listener(8090) {
    resource function post preIssueAccessTokenUpdateScopes(http:Request req) returns http:Response|error? {
        
        log:printInfo("Request Received to Update Scopes of the access token");
        ActionSuccessResponse respBody = {
            "actionStatus": SUCCESS,
            "operations": [
                {
                    op: ADD,
                    path: "/accessToken/scopes/-",
                    value: "custom-scope-1"
                },
                {
                    op: REMOVE,
                    path: "/accessToken/scopes/0"
                },
                {
                    op: REPLACE,
                    path: "/accessToken/scopes/2",
                    value: "groups"
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
        ActionSuccessResponse respBody = {
            "actionStatus": SUCCESS,
            "operations": [
                {
                    op: ADD,
                    path: "/accessToken/claims/aud/-",
                    value: "https://myextension.com"
                },
                {
                    op: REMOVE,
                    path: "/accessToken/claims/aud/1"
                },
                {
                    op: REPLACE,
                    path: "/accessToken/claims/aud/0",
                    value: "https://localhost:8090"
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
        ActionSuccessResponse respBody = {
            "actionStatus": SUCCESS,
            "operations": [
                {
                    op: REMOVE,
                    path: "/accessToken/claims/groups/0"
                },
                {
                    op: REPLACE,
                    path: "/accessToken/claims/groups/1",
                    value: "verifiedGroup1"
                },
                {
                    op: REPLACE,
                    path: "/accessToken/claims/phone_number",
                    value: "+94717525365"
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
        ActionSuccessResponse respBody = {
            "actionStatus": SUCCESS,
            "operations": [
                {
                    op: REPLACE,
                    path: "/accessToken/claims/expires_in",
                    value: "4000"
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
        ActionSuccessResponse respBody = {
            "actionStatus": SUCCESS,
            "operations": [
                {
                    op: ADD,
                    path: "/accessToken/claims/-",
                    value: {
                        name: "companyID",
                        value: "LK-2292"
                    }
                },
                {
                    op: ADD,
                    path: "/accessToken/claims/-",
                    value: {
                        name: "isPermanent",
                        value: true
                    }
                },
                {
                    op: ADD,
                    path: "/accessToken/claims/-",
                    value: {
                        name: "additionalRoles",
                        value: [
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
        ActionFailedResponse respBody = {
            actionStatus: ERROR,
            'error: "access_denied",
            error_description: "The user is not authorized to access the resource"
        };
        http:Response resp = new;
        resp.statusCode = 400;
        resp.setJsonPayload(respBody.toJson());

        return resp;
    }
}
