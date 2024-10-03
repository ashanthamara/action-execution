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

        ActionSuccessResponse respBody;
        http:Response resp = new;
        log:printInfo("Request Received to Update Scopes of the access token");
        json requestPayload = <json> check req.getJsonPayload();
        log:printInfo(requestPayload.toString());
        json grantType = check requestPayload.toJson().event.request.grantType;
        if (grantType == "refresh_token") {
            respBody = {
                "actionStatus": SUCCESS,
                "operations": [
                    {
                        op: REMOVE,
                        path: "/accessToken/scopes/0"
                    }
                ]
            };
        } else {
            respBody = {
                "actionStatus": SUCCESS,
                "operations": [
                    {
                        op: ADD,
                        path: "/accessToken/scopes/-",
                        value: "test_api_perm_3"
                    },
                    {
                        op: ADD,
                        path: "/accessToken/scopes/0",
                        value: "test_api_perm_2"
                    },
                    {
                        op: REMOVE,
                        path: "/accessToken/scopes/0"
                    },
                    {
                        op: REPLACE,
                        path: "/accessToken/scopes/1",
                        value: "test_api_perm_1"
                    }
                ]
            };
        }
        resp.statusCode = 200;
        resp.setJsonPayload(respBody.toJson());

        return resp;
    }

    resource function post preIssueAccessTokenUpdateAudience(http:Request req) returns http:Response|error? {
        
        ActionSuccessResponse respBody;
        http:Response resp = new;
        log:printInfo("Request Received to Update Audience of the access token");
        json requestPayload = <json> check req.getJsonPayload();
        log:printInfo(requestPayload.toString());
        json grantType = check requestPayload.toJson().event.request.grantType;
        if (grantType == "refresh_token") { 
            respBody = {
                "actionStatus": SUCCESS,
                "operations": [
                    {
                        op: REMOVE,
                        path: "/accessToken/claims/aud/0"
                    }
                ]
            };
        } else {
            respBody = {
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
        }
        resp.statusCode = 200;
        resp.setJsonPayload(respBody.toJson());

        return resp;
    }

    resource function post preIssueAccessTokenUpdateOidcClaims(http:Request req) returns http:Response|error? {

        ActionSuccessResponse respBody;
        http:Response resp = new;
        log:printInfo("Request Received to Update OIDC Claims of the access token");
        json requestPayload = <json> check req.getJsonPayload();
        log:printInfo(requestPayload.toString());
        json grantType = check requestPayload.toJson().event.request.grantType;
        if (grantType == "refresh_token") {
            respBody = {
                "actionStatus": SUCCESS,
                "operations": [
                    {
                        op: REMOVE,
                        path: "/accessToken/claims/groups/0"
                    }
                ]
            };
        } else {
            respBody = {
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
                        path: "/accessToken/claims/username",
                        value: "US/JohnDoe"
                    }
                ]
            };
        }
        resp.statusCode = 200;
        resp.setJsonPayload(respBody.toJson());

        return resp;
    }

    resource function post preIssueAccessTokenUpdateTokenExpiryTime(http:Request req) returns http:Response|error? {
        
        ActionSuccessResponse respBody;
        http:Response resp = new;
        log:printInfo("Request Received to Update Expiry Time of the access token");
        json requestPayload = <json> check req.getJsonPayload();
        log:printInfo(requestPayload.toString());
        json grantType = check requestPayload.toJson().event.request.grantType;
        if (grantType == "refresh_token") {
            respBody = {
                "actionStatus": SUCCESS,
                "operations": [
                    {
                        op: REPLACE,
                        path: "/accessToken/claims/expires_in",
                        value: "3000"
                    }
                ]
            };
        } else {
            respBody = {
                "actionStatus": SUCCESS,
                "operations": [
                    {
                        op: REPLACE,
                        path: "/accessToken/claims/expires_in",
                        value: "4000"
                    }
                ]
            };
        }
        resp.statusCode = 200;
        resp.setJsonPayload(respBody.toJson());

        return resp;   
    }

    resource function post preIssueAccessTokenAddCustomClaims(http:Request req) returns http:Response|error? {
        
        ActionSuccessResponse respBody;
        http:Response resp = new;
        log:printInfo("Request Received to Add Custom Claims to the access token");
        json requestPayload = <json> check req.getJsonPayload();
        log:printInfo(requestPayload.toString());
        json grantType = check requestPayload.toJson().event.request.grantType;
        if (grantType == "refresh_token") {
            string? prevGrantType = check getAccessTokenClaim(requestPayload, "grantType");
            if prevGrantType != null {
                respBody = {
                    "actionStatus": SUCCESS,
                    "operations": [
                        {
                            op: REPLACE,
                            path: "/accessToken/claims/grantType",
                            value: grantType.toString()
                        },
                        {
                            op: ADD,
                            path: "/accessToken/claims/-",
                            value: {
                                name: "previousGrantType",
                                value: prevGrantType
                            }
                        }
                    ]
                };
            } else {
                respBody = {
                    "actionStatus": SUCCESS,
                    "operations": [
                        {
                            op: ADD,
                            path: "/accessToken/claims/-",
                            value: {
                                name: "grantType",
                                value: grantType.toString()
                            }
                        }
                    ]
                };
            }
        } else {
            respBody = {
                "actionStatus": SUCCESS,
                "operations": [
                    {
                        op: ADD,
                        path: "/accessToken/claims/-",
                        value: {
                            name: "grantType",
                            value: grantType.toString()
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
                                "accountant",
                                "manager"
                            ]
                        }
                    }
                ]
            };
        }
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

// Function to get the email value from the claims
function getAccessTokenClaim(json requestPayload, string claimName) returns string|error? {
    json? claimsJson = check requestPayload.toJson().event.accessToken.claims;

    if claimsJson is json[] {
        foreach json claim in claimsJson {
            if claim.name == claimName {
                return (check claim.value).toString();
            }
        }
    }
    return null;
}
