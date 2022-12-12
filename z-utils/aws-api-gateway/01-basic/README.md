# Basic API Gateway setup

- This terraform sample creates AWS API Gateway for a (MOCKed) REST Service
* Following are the resources used in the sample 
    * aws_api_gateway_rest_api
    * aws_api_gateway_resource
    * aws_api_gateway_method
    * aws_api_gateway_integration
    * aws_api_gateway_method_response
    * aws_api_gateway_integration_response
- Inline comments with in the code will explain about every above resource
* Once deployed, we can test the API Gateway using AWS Console:
    * Open AWS Console
    * Search for "API Gateway"
    * Select "sample-rest-api"
    * Select "GET" under "/employee" resource
    * Click "Test" button
    * Skip "Query Strings", "Headers" etc. and click on "Test" at the bottom
    * Should return as follows:

```json
{
    "empno":1001,
    "ename":"Jag"
}
```