# Basic Lambda

NOTE: Need to execute `npm install` in `node-js-sample\app` manually prior to executing Terraform script

- This terraform sample deploys the node.js based lambda function
* Following are the steps included in the sample 
    * Create IAM Role for Lambda
    * Create IAM Policy for Lambda
    * Associate IAM Policy with IAM Role
    * Create a zip file for all contents in "app" folder (including node_modules)
        * `npm install` is not automated in the script.  Need to do manually before executing the script
    * Create AWS Lambda function from the zip file
- The IAM Policy includes writing to CloudWatch logs


