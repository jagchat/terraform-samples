// Regular expression to extract an access token from
// Authorization header.
var BEARER_TOKEN_PATTERN = /^Bearer[ ]+([^ ]+)[ ]*$/i;

// A function to extract an access token from Authorization header.
//
// This function assumes the value complies with the format described
// in "RFC 6750, 2.1. Authorization Request Header Field". For example,
// if "Bearer 123" is given to this function, "123" is returned.
function extract_access_token(authorization)
{
  // If the value of Authorization header is not available.
  if (!authorization)
  {
    // No access token.
    return null;
  }

  // Check if it matches the pattern "Bearer {access-token}".
  var result = BEARER_TOKEN_PATTERN.exec(authorization);

  // If the Authorization header does not match the pattern.
  if (!result)
  {
    // No access token.
    return null;
  }

  // Return the access token.
  return result[1];
}

// A function to generate a success response from Authorizer to API Gateway.
function generate_allow_policy()
{
  return {
    principalId: "admin",
    policyDocument: {
      Version: '2012-10-17',
      Statement: [{
        Action: 'execute-api:Invoke',
        Effect: 'Allow',
        Resource: 'arn:aws:execute-api:*:*:*' //typically for the respective lambda arn
      }]
    }
  };
}

exports.handler = (event, context, callback) => {
    //console.log("ENVIRONMENT VARIABLES\n" + JSON.stringify(process.env, null, 2)) 
	console.info("EVENT\n" + JSON.stringify(event, null, 2))

    console.info("handler.Started..");

    // The access token presented by the client application.
    var access_token = extract_access_token(event.authorizationToken);

    //TODO: validate "access_token" here

    // If the request from the client does not contain an access token.
    if (!access_token) {
        context.fail("Unauthorized");
        return;
    }

    context.succeed(generate_allow_policy());
};
