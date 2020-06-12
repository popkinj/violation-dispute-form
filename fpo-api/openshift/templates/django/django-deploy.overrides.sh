_includeFile=$(type -p overrides.inc)
if [ ! -z ${_includeFile} ]; then
  . ${_includeFile}
else
  _red='\033[0;31m'; _yellow='\033[1;33m'; _nc='\033[0m'; echo -e \\n"${_red}overrides.inc could not be found on the path.${_nc}\n${_yellow}Please ensure the openshift-developer-tools are installed on and registered on your path.${_nc}\n${_yellow}https://github.com/BCDevOps/openshift-developer-tools${_nc}"; exit 1;
fi

# ================================================================================================================
# Special deployment parameters needed for injecting a user supplied settings into the deployment configuration
# ----------------------------------------------------------------------------------------------------------------

if createOperation; then
  # Ask the user to supply the sensitive parameters ...
  readParameter "RECAPTCHA_SITE_KEY - Please provide reCAPTHCA site key for the application environment.  If left blank, a 48 character long base64 encoded value will be randomly generated using openssl:" RECAPTCHA_SITE_KEY $(generateKey) "false"
  readParameter "RECAPTCHA_SECRET_KEY - Please provide reCAPTHCA secret key for the application environment.  If left blank, a 48 character long base64 encoded value will be randomly generated using openssl:" RECAPTCHA_SECRET_KEY $(generateKey) "false"
else
  # Secrets are removed from the configurations during update operations ...
  printStatusMsg "Update operation detected ...\nSkipping the prompts for RECAPTCHA_SITE_KEY, and RECAPTCHA_SECRET_KEY secrets ... \n"
  writeParameter "RECAPTCHA_SITE_KEY" "prompt_skipped" "false"
  writeParameter "RECAPTCHA_SECRET_KEY" "prompt_skipped" "false"
fi

SPECIALDEPLOYPARMS="--param-file=${_overrideParamFile}"
echo ${SPECIALDEPLOYPARMS}