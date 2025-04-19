export CLAUDE_CODE_USE_BEDROCK=1
export AWS_PROFILE=dev
export AWS_REGION=us-west-2
export ANTHROPIC_MODEL=us.anthropic.claude-3-7-sonnet-20250219-v1:0

function write_aws_saml_credentials {
    if [[ ! -z "${ROVER_AWS_SAML_HELPER_CREDENTIALS:-}" ]]; then
        mkdir -p $HOME/.aws
        echo $ROVER_AWS_SAML_HELPER_CREDENTIALS | base64 -d > $HOME/.aws/credentials
    fi
}
# Write credentials on load if possible
write_aws_saml_credentials
