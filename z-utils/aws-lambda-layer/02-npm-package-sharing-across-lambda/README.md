# embed custom node.js and npm module in a layer for multiple lambda access

NOTE: Need to execute `npm install` in `sample-layer/nodejs` and `sample-layer/..../date-helper` manually prior to executing Terraform script

- This terraform sample deploys custom node.js module (date-helper) to a lambda layer
- The lambda layer also contains an npm module (faker-js) which is used in lambda functions
- Further, the sample deploys two lambda functions which use the above layer.
- Both lambda functions access faker-js and date-helper modules
