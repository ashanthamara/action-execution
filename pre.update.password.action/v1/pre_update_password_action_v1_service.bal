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

listener http:Listener ep0 = new (9091);

service / on ep0 {

    public function init() {
        log:printInfo("Pre Update Password Action E2E Service started.");
    }

    # handle pre-update password events
    #
    # + payload - parameter description 
    # + apiVersion - API version header
    # + authorization - Authorization header
    # + return - returns can be any of following types
    # OkInline_response_200 (Ok)
    # BadRequestErrorResponse (Bad Request)
    # InternalServerErrorErrorResponse (Server Error)
    resource function post preUpdatePassword(
        @http:Payload RequestBody payload,
        @http:Header { name: "x-wso2-api-version" } string apiVersion,
        @http:Header string authorization
    ) returns OkInline_response_200|BadRequestErrorResponse|InternalServerErrorErrorResponse {

        OkInline_response_200|BadRequestErrorResponse|InternalServerErrorErrorResponse response = validateHeaders(apiVersion, authorization);
        if (response is BadRequestErrorResponse || response is InternalServerErrorErrorResponse) {
            log:printInfo("Response: " + response.toString());
            return response;
        }
        
        log:printInfo("Pre Update Password Action request received: " + payload.toString());
        
        response = validatePassword(payload.event);
        log:printInfo("Response: " + response.toString());
        return response;
    }
}

function validatePassword(Event event) returns OkInline_response_200|BadRequestErrorResponse|InternalServerErrorErrorResponse {
    
    if (event.user.updatingCredential is UnencryptedCredential) {
        UnencryptedCredential unencryptedCredential = <UnencryptedCredential>event.user.updatingCredential;
        string password = unencryptedCredential.value;
        
        if (password == "myPassword@123") {
            return buildInternalServerErrorErrorResponse("Internal server error", "Please try again");
        } 
        if (password == "myPassword@1234") {
            return buildFailedResponse("Compromised password", "Provide a different password");
        } 
        
        return buildSuccessResponse();
    }

    return buildInternalServerErrorErrorResponse("Unable to decrypt the credential", "Please provide a unencrypted credential");
}

function validateHeaders(string apiVersion, string authorization) returns OkInline_response_200|BadRequestErrorResponse|InternalServerErrorErrorResponse {
    
    if (apiVersion != "v1") {
        return buildInternalServerErrorErrorResponse("Invalid API version", 
            "Provided API version: " + apiVersion + " is not equal to the current supported API version: v1");
    }
    if (authorization != "dGVzdC5lMmUucHJlLnVwZGF0ZS5wYXNzd29yZC5hY3Rpb24uYXV0aG9yaXphdGlvbi52YWx1ZQ==") {
        return buildBadRequestErrorResponse("Unauthorized", 
            "Invalid Credentials. Make sure you have provided the correct credentials for authentication");
    }
    
    return buildSuccessResponse();
}

function buildSuccessResponse() returns OkInline_response_200 {

    OkInline_response_200 response = { body: { actionStatus: "SUCCESS" } };
    return response;
}

function buildFailedResponse(string failureReason, string failureDescription) returns OkInline_response_200 {

    OkInline_response_200 response = { 
        body: { 
            actionStatus: "FAILED", 
            failureReason: failureReason, 
            failureDescription: failureDescription
        } 
    };
    return response;
}

function buildBadRequestErrorResponse(string errorMessage, string errorDescription) returns BadRequestErrorResponse {

    BadRequestErrorResponse response = { 
        body: { 
            actionStatus: "ERROR", 
            errorMessage: errorMessage, 
            errorDescription: errorDescription
        } 
    };
    return response;
}

function buildInternalServerErrorErrorResponse(string errorMessage, string errorDescription) returns InternalServerErrorErrorResponse {

    InternalServerErrorErrorResponse response = { 
        body: { 
            actionStatus: "ERROR", 
            errorMessage: errorMessage, 
            errorDescription: errorDescription
        } 
    };
    return response;
}
