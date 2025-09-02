// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/log;

listener http:Listener ep0 = new (9090);

service / on ep0 {

    public function init() {
        log:printInfo("Pre issue access token action e2e service started.");
    }

    # handle pre-issue access token events
    #
    # + payload - parameter description 
    # + apiVersion - API version header
    # + authorization - Authorization header
    # + return - returns can be any of following types
    # OkInline_response_200 (Ok)
    # BadRequestErrorResponse (Bad Request)
    # InternalServerErrorErrorResponse (Server Error)
    resource function post preIssueAccessTokenUpdateScopes(
        @http:Payload RequestBody payload,
        @http:Header { name: "x-wso2-api-version" } string apiVersion,
        @http:Header string authorization
    ) returns OkInline_response_200|BadRequestErrorResponse|InternalServerErrorErrorResponse {

        OkInline_response_200|BadRequestErrorResponse|InternalServerErrorErrorResponse response = validateHeaders(apiVersion, authorization);
        if (response is BadRequestErrorResponse || response is InternalServerErrorErrorResponse) {
            log:printInfo("Response: " + response.toString());
            return response;
        }

        log:printInfo("Request received to update scopes of the access token");
        log:printInfo(payload.toString());

        string grantType = payload.event.request.grantType;
        SuccessResponse respBody;
        if (grantType == "refresh_token") {
            respBody = {
                "actionStatus": "SUCCESS",
                "operations": [
                    {
                        op: "remove",
                        path: "/accessToken/scopes/0"
                    }
                ]
            };
        } else {
            respBody = {
                "actionStatus": "SUCCESS",
                "operations": [
                    {
                        op: "add",
                        path: "/accessToken/scopes/-",
                        value: "test_api_perm_3"
                    },
                    {
                        op: "add",
                        path: "/accessToken/scopes/0",
                        value: "test_api_perm_2"
                    },
                    {
                        op: "remove",
                        path: "/accessToken/scopes/0"
                    },
                    {
                        op: "replace",
                        path: "/accessToken/scopes/1",
                        value: "test_api_perm_1"
                    }
                ]
            };
        }
        OkInline_response_200 resp = {
            "body": respBody
        };
        log:printInfo("Response: " + resp.toString());
        return resp;
    }

    resource function post preIssueAccessTokenUpdateAudience(
        @http:Payload RequestBody payload,
        @http:Header { name: "x-wso2-api-version" } string apiVersion,
        @http:Header string authorization
    ) returns OkInline_response_200|BadRequestErrorResponse|InternalServerErrorErrorResponse {
        
        OkInline_response_200|BadRequestErrorResponse|InternalServerErrorErrorResponse response = validateHeaders(apiVersion, authorization);
        if (response is BadRequestErrorResponse || response is InternalServerErrorErrorResponse) {
            log:printInfo("Response: " + response.toString());
            return response;
        }

        log:printInfo("Request received to update audience of the access token");
        log:printInfo(payload.toString());
        
        string grantType = payload.event.request.grantType;
        SuccessResponse respBody;
        if (grantType == "refresh_token") { 
            respBody = {
                "actionStatus": "SUCCESS",
                "operations": [
                    {
                        op: "remove",
                        path: "/accessToken/claims/aud/0"
                    }
                ]
            };
        } else {
            respBody = {
                "actionStatus": "SUCCESS",
                "operations": [
                    {
                        op: "add",
                        path: "/accessToken/claims/aud/-",
                        value: "https://myextension.com"
                    },
                    {
                        op: "remove",
                        path: "/accessToken/claims/aud/1"
                    },
                    {
                        op: "replace",
                        path: "/accessToken/claims/aud/0",
                        value: "https://localhost:8090"
                    }
                ]
            };
        }
        OkInline_response_200 resp = {
            "body": respBody
        };
        log:printInfo("Response: " + resp.toString());
        return resp;
    }

    resource function post preIssueAccessTokenUpdateOidcClaims(
        @http:Payload RequestBody payload,
        @http:Header { name: "x-wso2-api-version" } string apiVersion,
        @http:Header string authorization
    ) returns OkInline_response_200|BadRequestErrorResponse|InternalServerErrorErrorResponse {

        OkInline_response_200|BadRequestErrorResponse|InternalServerErrorErrorResponse response = validateHeaders(apiVersion, authorization);
        if (response is BadRequestErrorResponse || response is InternalServerErrorErrorResponse) {
            log:printInfo("Response: " + response.toString());
            return response;
        }

        log:printInfo("Request received to update oidc claims of the access token");
        log:printInfo(payload.toString());
        
        string grantType = payload.event.request.grantType;
        SuccessResponse respBody;
        if (grantType == "refresh_token") {
            respBody = {
                "actionStatus": "SUCCESS",
                "operations": [
                    {
                        op: "remove",
                        path: "/accessToken/claims/groups/0"
                    }
                ]
            };
        } else {
            respBody = {
                "actionStatus": "SUCCESS",
                "operations": [
                    {
                        op: "remove",
                        path: "/accessToken/claims/groups/0"
                    },
                    {
                        op: "replace",
                        path: "/accessToken/claims/groups/1",
                        value: "verifiedGroup1"
                    },
                    {
                        op: "replace",
                        path: "/accessToken/claims/username",
                        value: "US/JohnDoe"
                    }
                ]
            };
        }
        OkInline_response_200 resp = {
            "body": respBody
        };
        log:printInfo("Response: " + resp.toString());
        return resp;
    }

    resource function post preIssueAccessTokenUpdateTokenExpiryTime(
        @http:Payload RequestBody payload,
        @http:Header { name: "x-wso2-api-version" } string apiVersion,
        @http:Header string authorization
    ) returns OkInline_response_200|BadRequestErrorResponse|InternalServerErrorErrorResponse {
        
        OkInline_response_200|BadRequestErrorResponse|InternalServerErrorErrorResponse response = validateHeaders(apiVersion, authorization);
        if (response is BadRequestErrorResponse || response is InternalServerErrorErrorResponse) {
            log:printInfo("Response: " + response.toString());
            return response;
        }

        log:printInfo("Request received to update expiry time of the access token");
        log:printInfo(payload.toString());
        
        string grantType = payload.event.request.grantType;
        SuccessResponse respBody;
        if (grantType == "refresh_token") {
            respBody = {
                "actionStatus": "SUCCESS",
                "operations": [
                    {
                        op: "replace",
                        path: "/accessToken/claims/expires_in",
                        value: "3000"
                    }
                ]
            };
        } else {
            respBody = {
                "actionStatus": "SUCCESS",
                "operations": [
                    {
                        op: "replace",
                        path: "/accessToken/claims/expires_in",
                        value: "4000"
                    }
                ]
            };
        }
        OkInline_response_200 resp = {
            "body": respBody
        };
        log:printInfo("Response: " + resp.toString());
        return resp;
    }

    resource function post preIssueAccessTokenAddCustomClaims(
        @http:Payload RequestBody payload,
        @http:Header { name: "x-wso2-api-version" } string apiVersion,
        @http:Header string authorization
    ) returns OkInline_response_200|BadRequestErrorResponse|InternalServerErrorErrorResponse {
        
        OkInline_response_200|BadRequestErrorResponse|InternalServerErrorErrorResponse response = validateHeaders(apiVersion, authorization);
        if (response is BadRequestErrorResponse || response is InternalServerErrorErrorResponse) {
            log:printInfo("Response: " + response.toString());
            return response;
        }

        log:printInfo("Request received to add custom claims the access token");
        log:printInfo(payload.toString());
        
        string grantType = payload.event.request.grantType;
        SuccessResponse respBody;
        if (grantType == "refresh_token") {
            (string|int|boolean|string[])? prevGrantType = getAccessTokenClaim(payload, "grantType");
            if prevGrantType != null {
                respBody = {
                    "actionStatus": "SUCCESS",
                    "operations": [
                        {
                            op: "replace",
                            path: "/accessToken/claims/grantType",
                            value: grantType.toString()
                        },
                        {
                            op: "add",
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
                    "actionStatus": "SUCCESS",
                    "operations": [
                        {
                            op: "add",
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
                "actionStatus": "SUCCESS",
                "operations": [
                    {
                        op: "add",
                        path: "/accessToken/claims/-",
                        value: {
                            name: "grantType",
                            value: grantType.toString()
                        }
                    },
                    {
                        op: "add",
                        path: "/accessToken/claims/-",
                        value: {
                            name: "isPermanent",
                            value: true
                        }
                    },
                    {
                        op: "add",
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
        OkInline_response_200 resp = {
            "body": respBody
        };
        log:printInfo("Response: " + resp.toString());
        return resp;   
    }   

    resource function post preIssueAccessTokenError(
        @http:Payload RequestBody payload,
        @http:Header { name: "x-wso2-api-version" } string apiVersion,
        @http:Header string authorization
    ) returns OkInline_response_200|BadRequestErrorResponse|InternalServerErrorErrorResponse {
        
        OkInline_response_200|BadRequestErrorResponse|InternalServerErrorErrorResponse response = validateHeaders(apiVersion, authorization);
        if (response is BadRequestErrorResponse || response is InternalServerErrorErrorResponse) {
            log:printInfo("Response: " + response.toString());
            return response;
        }

        log:printInfo("Request Received to simulate an error");
        log:printInfo(payload.toString());

        InternalServerErrorErrorResponse resp = {
            body: {
                actionStatus: "ERROR",
                errorMessage: "Internal server error",
                errorDescription: "Please try again"
            }
        };
        log:printInfo("Response: " + resp.toString());
        return resp; 
    }

    resource function post preIssueAccessTokenFailure(
        @http:Payload RequestBody payload,
        @http:Header { name: "x-wso2-api-version" } string apiVersion,
        @http:Header string authorization
    ) returns OkInline_response_200|BadRequestErrorResponse|InternalServerErrorErrorResponse {
        
        OkInline_response_200|BadRequestErrorResponse|InternalServerErrorErrorResponse response = validateHeaders(apiVersion, authorization);
        if (response is BadRequestErrorResponse || response is InternalServerErrorErrorResponse) {
            log:printInfo("Response: " + response.toString());
            return response;
        }

        log:printInfo("Request Received to simulate a failure");
        log:printInfo(payload.toString());

        OkInline_response_200 resp = {
            body: {
                actionStatus: "FAILED",
                failureReason: "User account is locked",
                failureDescription: "Please complete necessary verification steps to unlock the account"
            }
        };
        log:printInfo("Response: " + resp.toString());
        return resp; 
    }

    resource function post testHeadersAndParams(
        @http:Payload RequestBody payload,
        @http:Header { name: "x-wso2-api-version" } string apiVersion,
        @http:Header string authorization
    ) returns OkInline_response_200|BadRequestErrorResponse|InternalServerErrorErrorResponse {
        
        OkInline_response_200|BadRequestErrorResponse|InternalServerErrorErrorResponse response = validateHeaders(apiVersion, authorization);
        if (response is BadRequestErrorResponse || response is InternalServerErrorErrorResponse) {
            log:printInfo("Response: " + response.toString());
            return response;
        }

        log:printInfo("Request Received to test headers and params");
        log:printInfo(payload.toString());

        AddOperationResponse[] addOperations = [];
        RequestHeaders[]? reqHeaders = payload.event?.request?.additionalHeaders;
        if reqHeaders is RequestHeaders[] {
            foreach var header in reqHeaders {
                AddOperationResponse addHeader = {
                    op: "add",
                    path: "/accessToken/claims/-",
                    value: {
                        name: header.name,
                        value: header.value
                    }
                };
                addOperations.push(addHeader);
            }
        } else {
            AddOperationResponse addHeader = {
                op: "add",
                path: "/accessToken/claims/-",
                value: {
                    name: "isHeadersAvailable",
                    value: false
                }
            };
            addOperations.push(addHeader);
        }

        RequestParams[]? reqParams = payload.event?.request?.additionalParams;
        if reqParams is RequestParams[] {
            foreach var param in reqParams {
                AddOperationResponse addParam = {
                    op: "add",
                    path: "/accessToken/claims/-",
                    value: {
                        name: param.name,
                        value: param.value
                    }
                };
                addOperations.push(addParam);
            }
        } else {
            AddOperationResponse addParam = {
                op: "add",
                path: "/accessToken/claims/-",
                value: {
                    name: "isParamsAvailable",
                    value: false
                }
            };
            addOperations.push(addParam);
        }


        OkInline_response_200 resp = {
            "body": {
                actionStatus: "SUCCESS",
                operations: addOperations
            }
        };
        log:printInfo("Response: " + resp.toString());
        return resp; 
    }
}

// Function to get the email value from the claims
function getAccessTokenClaim(RequestBody requestPayload, string claimName) returns (string|int|boolean|string[])? {
    
    AccessTokenClaims[] claims = requestPayload.event.accessToken.claims;
    foreach AccessTokenClaims claim in claims {
        if claim.name == claimName {
            return claim.value;
        }
    }
    return null;
}

function validateHeaders(string apiVersion, string authorization) returns OkInline_response_200|BadRequestErrorResponse|InternalServerErrorErrorResponse {
    
    if (apiVersion != "v1") {
        InternalServerErrorErrorResponse response = {
            body: {
                actionStatus: "ERROR",
                errorMessage: "Invalid API version",
                errorDescription: "Provided API version: " + apiVersion + " is not equal to the current supported API version: v1"
            }
        };
        return response;
    }
    if (authorization != "dGVzdC5lMmUucHJlLmlzc3VlLmFjY2Vzcy50b2tlbi5hY3Rpb24uYXV0aG9yaXphdGlvbi52YWx1ZQ==") {
        BadRequestErrorResponse response = {
            body: {
                actionStatus: "ERROR",
                errorMessage: "Unauthorized",
                errorDescription: "Invalid Credentials. Make sure you have provided the correct credentials for authentication"
            }
        };
        return response;
    }
    
    OkInline_response_200 response = { body: { actionStatus: "SUCCESS" } };
    return response;
}
