npm install -g @anthropic-ai/claude-code

function write_aws_saml_credentials {
    if [[ ! -z "${ROVER_AWS_SAML_HELPER_CREDENTIALS:-}" ]]; then
        mkdir -p $HOME/.aws
        echo $ROVER_AWS_SAML_HELPER_CREDENTIALS | base64 -d > $HOME/.aws/credentials
    fi
}
# Write credentials on load if possible
write_aws_saml_credentials
